# Wallet and Stocks API

This project is an API built with Ruby on Rails that manages user wallets, stocks, and stock transactions. The API allows users to check their wallet balance and the total value of their stock assets.

## Features
- **Wallet Balance**: Retrieve the balance of the user's wallet.
- **Assets Balance**: Calculate and retrieve the total value of the user's stocks based on quantity and last price.
- **Stock Transactions**: Track and manage user stock transactions.

## Models

1. **User**
   - Represents a user in the system.
   - Each user has a wallet and may own multiple stocks.

2. **Wallet**
   - Belongs to a user.
   - Contains a `balance` field representing the current cash balance of the user.

3. **Stock**
   - Belongs to a user.
   - Contains `quantity` of stocks owned and `stock_data` for details like `lastPrice`.
   - `value` method calculates the total value of the stock as `quantity * lastPrice`.

4. **Transaction**
   - Belongs to a stock.
   - Represents individual transactions for buying or selling stocks.

## Usage
Check Wallet and Assets Balance
Send a GET request to /wallets/check_balance with the appropriate authentication headers if required.

#### Postman Collection
You can use the Postman collection to test the API. Import the following collection into your Postman:

Postman Collection Link: https://api.postman.com/collections/14861101-98360de7-e920-4c3e-b7f3-b20b74d72f9e?access_key=PMAT-01JBDSW2M3A79KVFVN448C1QHD
