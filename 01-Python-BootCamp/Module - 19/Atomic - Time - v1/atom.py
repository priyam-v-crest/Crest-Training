import tkinter as tk
from tkinter import ttk
import time
import threading
import ntplib
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

# Atomic tick frequency for cesium-133
CESIUM_TICKS_PER_SECOND = 9_192_631_770

# Simulates atomic clock with drift
class AtomicClockSimulator:
    def __init__(self, drift_ppb=50):
        self.drift_ppb = drift_ppb  # drift in parts per billion
        self.reset()

    def reset(self):
        self.start_time = time.time()
        self.start_ticks = 0
        self.running = True

    def pause(self):
        if self.running:
            self.start_ticks = self.get_current_tick()
            self.running = False

    def resume(self):
        if not self.running:
            self.start_time = time.time()
            self.running = True

    def get_current_tick(self):
        elapsed = time.time() - self.start_time if self.running else 0
        drifted_frequency = CESIUM_TICKS_PER_SECOND * (1 + self.drift_ppb / 1_000_000_000)
        return self.start_ticks + int(elapsed * drifted_frequency)

    def get_simulated_time(self):
        ticks = self.get_current_tick()
        return ticks / CESIUM_TICKS_PER_SECOND

# Fetches NTP time from atomic clock pool
def get_ntp_time():
    try:
        client = ntplib.NTPClient()
        response = client.request('pool.ntp.org', version=3)
        return response.tx_time
    except Exception as e:
        print("NTP Error:", e)
        return None

class ClockUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Atomic Clock Simulator with Drift")
        self.root.geometry("850x650")
        self.root.configure(bg="#121212")

        self.clock = AtomicClockSimulator(drift_ppb=1000)  
        self.ntp_time = None
        self.last_ntp_update = 0
        self.drift_data = []

        self.build_ui()
        self.update_loop()

    def build_ui(self):
        font_main = ("Courier", 14)
        
        self.label_atomic = tk.Label(self.root, text="Atomic Time:", fg="cyan", bg="#121212", font=font_main)
        self.label_atomic.pack(pady=5)

        self.label_system = tk.Label(self.root, text="System Time:", fg="orange", bg="#121212", font=font_main)
        self.label_system.pack(pady=5)

        self.label_drift = tk.Label(self.root, text="Drift vs System:", fg="red", bg="#121212", font=font_main)
        self.label_drift.pack(pady=5)

        self.label_ntp = tk.Label(self.root, text="NTP Time:", fg="green", bg="#121212", font=font_main)
        self.label_ntp.pack(pady=5)

        self.label_ntp_drift = tk.Label(self.root, text="Drift vs NTP:", fg="yellow", bg="#121212", font=font_main)
        self.label_ntp_drift.pack(pady=5)

        button_frame = tk.Frame(self.root, bg="#121212")
        button_frame.pack(pady=10)

        ttk.Style().configure('TButton', font=('Helvetica', 10, 'bold'))

        ttk.Button(button_frame, text="Start", command=self.clock.resume).grid(row=0, column=0, padx=10)
        ttk.Button(button_frame, text="Pause", command=self.clock.pause).grid(row=0, column=1, padx=10)
        ttk.Button(button_frame, text="Reset", command=self.reset).grid(row=0, column=2, padx=10)

        self.fig, self.ax = plt.subplots(figsize=(7, 3), dpi=100)
        self.ax.set_title("Live Drift vs NTP (seconds)")
        self.ax.set_xlabel("Time (s)")
        self.ax.set_ylabel("Drift")
        self.line, = self.ax.plot([], [], color='yellow')

        self.canvas = FigureCanvasTkAgg(self.fig, master=self.root)
        self.canvas.get_tk_widget().pack(pady=10)

    def format_time(self, seconds):
        return time.strftime("%H:%M:%S", time.gmtime(seconds))

    def update_graph(self):
        times = list(range(len(self.drift_data)))
        self.line.set_data(times, self.drift_data)

        window = self.drift_data[-50:] or [0]
        min_drift = min(window)
        max_drift = max(window)
        buffer = (max_drift - min_drift) * 0.5 or 0.01

        self.ax.set_xlim(0, max(50, len(self.drift_data)))
        self.ax.set_ylim(min_drift - buffer, max_drift + buffer)

        self.canvas.draw()

    def update_loop(self):
        atomic_time = self.clock.get_simulated_time()
        system_time = time.time()

        self.label_atomic.config(text=f"Atomic Time: {self.format_time(atomic_time)}")
        self.label_system.config(text=f"System Time: {self.format_time(system_time)}")

        drift_sys = atomic_time - system_time
        self.label_drift.config(text=f"Drift vs System: {drift_sys:+.6f} s")

        if time.time() - self.last_ntp_update > 10:
            threading.Thread(target=self.fetch_ntp_time, daemon=True).start()

        if self.ntp_time:
            self.label_ntp.config(text=f"NTP Time: {self.format_time(self.ntp_time)}")
            drift_ntp = atomic_time - self.ntp_time
            self.label_ntp_drift.config(text=f"Drift vs NTP: {drift_ntp:+.6f} s")

            self.drift_data.append(drift_ntp)
            if len(self.drift_data) > 100:
                self.drift_data.pop(0)
            self.update_graph()

        self.root.after(500, self.update_loop)

    def fetch_ntp_time(self):
        ntp = get_ntp_time()
        if ntp:
            self.ntp_time = ntp
            self.last_ntp_update = time.time()

    def reset(self):
        self.clock.reset()
        self.drift_data = []

if __name__ == "__main__":
    root = tk.Tk()
    app = ClockUI(root)
    root.mainloop()