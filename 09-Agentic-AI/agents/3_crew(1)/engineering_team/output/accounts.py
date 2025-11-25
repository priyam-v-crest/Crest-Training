class Account:
    """
    A class representing a user account in a trading simulation platform.
    """

    def __init__(self, username: str, initial_deposit: float):
        """
        Initializes a new user account.
        
        :param username: The username of the account holder.
        :param initial_deposit: The initial deposit amount.
        """
        if initial_deposit < 0:
            raise ValueError("Initial deposit cannot be negative.")
        self.username = username
        self.balance = initial_deposit
        self.initial_deposit = initial_deposit
        self.portfolio = {}  # dictionary to hold share quantities
        self.transactions = []  # list to hold transaction history

    def deposit(self, amount: float) -> None:
        """
        Deposits funds into the user's account.
        
        :param amount: The amount to deposit.
        """
        if amount <= 0:
            raise ValueError("Deposit amount must be greater than zero.")
        self.balance += amount
        self.transactions.append(f"Deposited: ${amount}")

    def withdraw(self, amount: float) -> None:
        """
        Withdraws funds from the user's account.
        
        :param amount: The amount to withdraw.
        :raises ValueError: If the withdrawal would leave a negative balance.
        """
        if amount <= 0:
            raise ValueError("Withdrawal amount must be greater than zero.")
        if amount > self.balance:
            raise ValueError("Insufficient balance for withdrawal.")
        self.balance -= amount
        self.transactions.append(f"Withdrew: ${amount}")

    def buy_shares(self, symbol: str, quantity: int) -> None:
        """
        Records the purchase of shares.
        
        :param symbol: The stock symbol.
        :param quantity: The number of shares to buy.
        :raises ValueError: If insufficient funds are available for the purchase.
        """
        if quantity <= 0:
            raise ValueError("Quantity to buy must be positive.")
        price_per_share = get_share_price(symbol)
        if price_per_share <= 0:
            raise ValueError(f"Share price for symbol {symbol} is not available or invalid.")
        total_cost = price_per_share * quantity
        if total_cost > self.balance:
            raise ValueError("Insufficient funds to purchase shares.")
        self.balance -= total_cost
        if symbol in self.portfolio:
            self.portfolio[symbol] += quantity
        else:
            self.portfolio[symbol] = quantity
        self.transactions.append(f"Bought {quantity} shares of {symbol} at ${price_per_share} each.")

    def sell_shares(self, symbol: str, quantity: int) -> None:
        """
        Records the sale of shares.
        
        :param symbol: The stock symbol.
        :param quantity: The number of shares to sell.
        :raises ValueError: If attempting to sell shares not owned.
        """
        if quantity <= 0:
            raise ValueError("Quantity to sell must be positive.")
        if symbol not in self.portfolio or self.portfolio[symbol] < quantity:
            raise ValueError("Not enough shares to sell.")
        price_per_share = get_share_price(symbol)
        if price_per_share <= 0:
            raise ValueError(f"Share price for symbol {symbol} is not available or invalid.")
        total_income = price_per_share * quantity
        self.balance += total_income
        self.portfolio[symbol] -= quantity
        if self.portfolio[symbol] == 0:
            del self.portfolio[symbol]
        self.transactions.append(f"Sold {quantity} shares of {symbol} at ${price_per_share} each.")

    def get_portfolio_value(self) -> float:
        """
        Calculates the total value of the user's portfolio.
        
        :return: The total value of the portfolio.
        """
        total_value = self.balance
        for symbol, quantity in self.portfolio.items():
            total_value += get_share_price(symbol) * quantity
        return total_value

    def get_profit_loss(self) -> float:
        """
        Calculates profit or loss based on the initial deposit.
        
        :return: The profit or loss amount.
        """
        return self.get_portfolio_value() - self.initial_deposit

    def report_holdings(self) -> dict:
        """
        Reports the holdings of the user at any point in time.
        
        :return: A dictionary of holdings with quantities.
        """
        return self.portfolio.copy()

    def report_profit_loss(self) -> float:
        """
        Reports the current profit or loss of the user at any point in time.
        
        :return: The current profit or loss amount.
        """
        return self.get_profit_loss()

    def list_transactions(self) -> list:
        """
        Lists all transactions made by the user over time.
        
        :return: A list of transaction records.
        """
        return self.transactions.copy()


def get_share_price(symbol: str) -> float:
    """
    Fetches the current price of a share given a stock symbol.
    This is a stub implementation returning fixed prices for testing.

    :param symbol: The stock symbol.
    :return: The current price of the share.
    """
    prices = {
        "AAPL": 150.00,
        "TSLA": 1000.00,
        "GOOGL": 2800.00
    }
    return prices.get(symbol, 0.0)  # defaults to 0.0 for unknown symbols


# Example test cases that could be used to verify functionality
if __name__ == "__main__":
    acc = Account("testuser", 10000)
    acc.deposit(5000)
    print(acc.balance)  # 15000
    acc.buy_shares("AAPL", 50)  # 50 * 150 = 7500
    print(acc.balance)  # 7500
    acc.sell_shares("AAPL", 20)  # 20 * 150 = 3000
    print(acc.balance)  # 10500
    print(acc.get_portfolio_value())  # balance + 30*150 = 10500 + 4500 = 15000
    print(acc.get_profit_loss())  # portfolio value - initial deposit = 15000 - 10000 = 5000
    acc.withdraw(2000)
    print(acc.balance)  # 8500
    print(acc.report_holdings())  # {"AAPL": 30}
    print(acc.report_profit_loss())  # current profit or loss
    print(acc.list_transactions())