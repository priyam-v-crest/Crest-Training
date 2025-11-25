import gradio as gr
from accounts import Account, get_share_price

# Initialize the account
account = Account("testuser", 10000)

def deposit(amount):
    account.deposit(amount)
    return f"Deposited: ${amount}, New Balance: ${account.balance}"

def withdraw(amount):
    try:
        account.withdraw(amount)
        return f"Withdrew: ${amount}, New Balance: ${account.balance}"
    except ValueError as e:
        return str(e)

def buy_shares(symbol, quantity):
    try:
        account.buy_shares(symbol, int(quantity))
        return f"Bought {quantity} shares of {symbol}, New Balance: ${account.balance}"
    except ValueError as e:
        return str(e)

def sell_shares(symbol, quantity):
    try:
        account.sell_shares(symbol, int(quantity))
        return f"Sold {quantity} shares of {symbol}, New Balance: ${account.balance}"
    except ValueError as e:
        return str(e)

def portfolio_value():
    return f"Total Portfolio Value: ${account.get_portfolio_value()}"

def profit_loss():
    return f"Profit/Loss: ${account.get_profit_loss()}"

def holdings():
    return f"Current Holdings: {account.report_holdings()}"

def transactions():
    return f"Transaction History: {account.list_transactions()}"

# Create the Gradio interface
with gr.Blocks() as demo:
    gr.Markdown("## Trading Account Management System")
    
    # Deposit
    with gr.Row():
        deposit_amount = gr.Number(label="Deposit Amount")
        deposit_button = gr.Button("Deposit")
        deposit_output = gr.Textbox(label="Deposit Output")
        deposit_button.click(deposit, inputs=deposit_amount, outputs=deposit_output)

    # Withdraw
    with gr.Row():
        withdraw_amount = gr.Number(label="Withdraw Amount")
        withdraw_button = gr.Button("Withdraw")
        withdraw_output = gr.Textbox(label="Withdraw Output")
        withdraw_button.click(withdraw, inputs=withdraw_amount, outputs=withdraw_output)

    # Buy Shares
    with gr.Row():
        buy_symbol = gr.Textbox(label="Stock Symbol (e.g., AAPL)")
        buy_quantity = gr.Number(label="Quantity")
        buy_button = gr.Button("Buy Shares")
        buy_output = gr.Textbox(label="Buy Output")
        buy_button.click(buy_shares, inputs=[buy_symbol, buy_quantity], outputs=buy_output)

    # Sell Shares
    with gr.Row():
        sell_symbol = gr.Textbox(label="Stock Symbol (e.g., AAPL)")
        sell_quantity = gr.Number(label="Quantity")
        sell_button = gr.Button("Sell Shares")
        sell_output = gr.Textbox(label="Sell Output")
        sell_button.click(sell_shares, inputs=[sell_symbol, sell_quantity], outputs=sell_output)

    # Portfolio Value
    value_button = gr.Button("Get Portfolio Value")
    value_output = gr.Textbox(label="Portfolio Value Output")
    value_button.click(portfolio_value, outputs=value_output)

    # Profit/Loss
    profit_loss_button = gr.Button("Get Profit/Loss")
    profit_loss_output = gr.Textbox(label="Profit/Loss Output")
    profit_loss_button.click(profit_loss, outputs=profit_loss_output)

    # Holdings
    holdings_button = gr.Button("Get Current Holdings")
    holdings_output = gr.Textbox(label="Holdings Output")
    holdings_button.click(holdings, outputs=holdings_output)

    # Transactions
    transactions_button = gr.Button("Get Transaction History")
    transactions_output = gr.Textbox(label="Transactions Output")
    transactions_button.click(transactions, outputs=transactions_output)

# Launch the Gradio app
demo.launch()