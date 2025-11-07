
import os
import json
import sqlite3
from datetime import datetime
from typing import List, Dict, Any

import streamlit as st
import google.generativeai as genai

# -----------------------------
# App Config
# -----------------------------
st.set_page_config(page_title="SarcastiChat (Gemini + Memory)", page_icon="\U0001F9E0", layout="wide")

PRIMARY_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")  
SYSTEM_INSTRUCTION = (
    "You are SarcastiChat: a witty, sarcastic assistant who still gives correct, helpful answers. "
    "You remember prior context from this conversation and past sessions (when provided). "
    "Keep the sarcasm playful, never mean-spirited. Avoid offensive or harmful content. "
    "If user asks for unsafe content, refuse politely with a dry wink."
)

GENERATION_CONFIG = {
    "temperature": 0.7,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 2048,
}

SAFETY_SETTINGS = None .

DB_PATH = os.getenv("CHAT_DB_PATH", "chat_memory.db")

# -----------------------------
# Utilities: SQLite memory
# -----------------------------
def get_conn():
    conn = sqlite3.connect(DB_PATH, check_same_thread=False)
    conn.execute(
        "CREATE TABLE IF NOT EXISTS conversations ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "title TEXT NOT NULL,"
        "created_at TEXT NOT NULL"
        ")"
    )
    conn.execute(
        "CREATE TABLE IF NOT EXISTS messages ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "conversation_id INTEGER NOT NULL,"
        "role TEXT NOT NULL,"
        "content TEXT NOT NULL,"
        "ts TEXT NOT NULL,"
        "FOREIGN KEY(conversation_id) REFERENCES conversations(id)"
        ")"
    )
    return conn

def create_conversation(conn, title: str) -> int:
    cur = conn.cursor()
    cur.execute("INSERT INTO conversations (title, created_at) VALUES (?, ?)", (title, datetime.utcnow().isoformat()))
    conn.commit()
    return cur.lastrowid

def list_conversations(conn) -> List[Dict[str, Any]]:
    cur = conn.cursor()
    cur.execute("SELECT id, title, created_at FROM conversations ORDER BY id DESC")
    rows = cur.fetchall()
    return [{"id": r[0], "title": r[1], "created_at": r[2]} for r in rows]

def rename_conversation(conn, conv_id: int, new_title: str):
    conn.execute("UPDATE conversations SET title=? WHERE id=?", (new_title, conv_id))
    conn.commit()

def delete_conversation(conn, conv_id: int):
    conn.execute("DELETE FROM messages WHERE conversation_id=?", (conv_id,))
    conn.execute("DELETE FROM conversations WHERE id=?", (conv_id,))
    conn.commit()

def add_message(conn, conv_id: int, role: str, content: str):
    conn.execute(
        "INSERT INTO messages (conversation_id, role, content, ts) VALUES (?, ?, ?, ?)",
        (conv_id, role, content, datetime.utcnow().isoformat()),
    )
    conn.commit()

def get_messages(conn, conv_id: int) -> List[Dict[str, Any]]:
    cur = conn.cursor()
    cur.execute("SELECT role, content, ts FROM messages WHERE conversation_id=? ORDER BY id ASC", (conv_id,))
    rows = cur.fetchall()
    return [{"role": r[0], "content": r[1], "ts": r[2]} for r in rows]

def export_conversation(conn, conv_id: int) -> Dict[str, Any]:
    cur = conn.cursor()
    cur.execute("SELECT title, created_at FROM conversations WHERE id=?", (conv_id,))
    row = cur.fetchone()
    if not row:
        return {}
    title, created_at = row
    messages = get_messages(conn, conv_id)
    return {"id": conv_id, "title": title, "created_at": created_at, "messages": messages}

# -----------------------------
# Gemini helpers
# -----------------------------
def to_gemini_history(messages: List[Dict[str, str]]) -> List[Dict[str, Any]]:
    # Gemini expects [{"role": "user"/"model", "parts": [text]}]
    hist = []
    for m in messages[-50:]:  # cap history to last 50 messages
        role = "user" if m["role"] == "user" else "model"
        hist.append({"role": role, "parts": [m["content"]]})
    return hist

def get_model(api_key: str):
    genai.configure(api_key=api_key)
    return genai.GenerativeModel(
        model_name=PRIMARY_MODEL,
        system_instruction=SYSTEM_INSTRUCTION
    )

# -----------------------------
# Sidebar
# -----------------------------
with st.sidebar:
    st.title("\U0001F9E0 SarcastiChat")
    st.caption("Gemini + Streamlit + SQLite memory")

    api_key = st.text_input("Gemini API Key", type="password", placeholder="AIza...")
    st.info("Add your Gemini API key to start. You can set an environment variable GEMINI_API_KEY as well.", icon="\U0001F511")

    if not api_key:
        api_key = os.getenv("GEMINI_API_KEY", "")

    st.divider()

    conn = get_conn()

    st.subheader("\U0001F4AC Conversations")
    convs = list_conversations(conn)
    conv_options = {f'#{c["id"]} - {c["title"]}': c["id"] for c in convs}

    if "conversation_id" not in st.session_state:
        if convs:
            st.session_state.conversation_id = convs[0]["id"]
        else:
            st.session_state.conversation_id = create_conversation(conn, "New chat")

    selected = st.selectbox(
        "Select conversation",
        options=list(conv_options.keys()) if convs else ["#1 - New chat"],
        index=0 if convs else 0
    )
    if convs:
        st.session_state.conversation_id = conv_options[selected]

    col_a, col_b, col_c = st.columns(3)
    with col_a:
        if st.button("\u2795 New"):
            st.session_state.conversation_id = create_conversation(conn, "New chat")
            st.rerun()
    with col_b:
        new_title = st.text_input("Rename title", value="")
        if st.button("\u270F\uFE0F Rename") and new_title.strip():
            rename_conversation(conn, st.session_state.conversation_id, new_title.strip())
            st.rerun()
    with col_c:
        if st.button("\U0001F5D1\uFE0F Delete"):
            delete_conversation(conn, st.session_state.conversation_id)
            st.rerun()

    st.divider()
    if st.button("\u2B07\uFE0F Export JSON"):
        data = export_conversation(conn, st.session_state.conversation_id)
        st.download_button("Download current conversation", data=json.dumps(data, indent=2), file_name=f"conversation_{st.session_state.conversation_id}.json", mime="application/json")

    st.caption(f"DB path: {DB_PATH}")

# -----------------------------
# Main Chat UI
# -----------------------------
st.title("SarcastiChat \U0001F916\uFE0F\U0001F4AC")
st.write("A *delightfully* sarcastic chatbot that **remembers**. You're welcome.")

if not api_key:
    st.warning("Please provide your Gemini API key in the sidebar to begin.", icon="\u26A0\uFE0F")
    st.stop()

# Load history & start chat
history = get_messages(conn, st.session_state.conversation_id)
for m in history:
    with st.chat_message("user" if m["role"] == "user" else "assistant"):
        st.markdown(m["content"])

# Start Gemini chat with prior context
model = get_model(api_key)
chat = model.start_chat(history=to_gemini_history(history))

# Input
user_input = st.chat_input("Say something snark-worthy...")
if user_input:
    # Show user message immediately
    with st.chat_message("user"):
        st.markdown(user_input)
    add_message(conn, st.session_state.conversation_id, "user", user_input)

    # Send to Gemini
    try:
        response = chat.send_message(
            user_input,
            generation_config=GENERATION_CONFIG,
            safety_settings=SAFETY_SETTINGS,
        )
        bot_text = response.text
    except Exception as e:
        bot_text = f"Oops, my circuits tripped: `{e}`. Try again after fixing the obvious."

    with st.chat_message("assistant"):
        st.markdown(bot_text)
    add_message(conn, st.session_state.conversation_id, "assistant", bot_text)

st.caption("Pro tip: In Colab, mount Google Drive and set CHAT_DB_PATH to persist memory across sessions.")
