//-----------------------------------------------------------------*
//-- Amirhossein Sabagh | #152956199 | Assignment 2 | 2020-12-06 --*
//-----------------------------------------------------------------*

#include <iostream>
#include <occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;


/*********** ShoppingCart struct ***********/
struct ShoppingCart {
	int product_id;
	double price;
	int quantity;
};

/*********** Function prototype ***********/
int mainMenu();
int customerLogin(Connection* conn, int custId);
int addToCart(Connection* conn, ShoppingCart cart[]);
double findProduct(Connection* conn, int product_id);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart car[], int customerId, int productCount);


int main() {
	Environment* env = nullptr;
	Connection* conn = nullptr;

	string user = "dbs311_203e30";
	string pass = "23425819";
	string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

	try {
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(user, pass, constr);
		cout << "Connection is successful!" << endl;

		int selection = -1, count = -1, cust_no = -1;
		while (selection != 0) {
			selection = mainMenu();

			if (selection == 1) {
				cout << "Enter the customer ID: ";
				cin >> cust_no;

				if (customerLogin(conn, cust_no) == 0) {
					cout << "The customer does not exist." << endl;
				}
				else {
					ShoppingCart cart[5];
					count = addToCart(conn, cart);
					displayProducts(cart, count);
					checkout(conn, cart, cust_no, count);
				}

			}
		}

		cout << "Good bye!..." << endl;

		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);
	}
	catch (SQLException& sqlExcp) {
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
	return 0;
}

// Main Menu
int mainMenu() { 
	int selection = 0;

	do {
		cout << "******************** Main Menu by Sabagh ********************\n"
			<< "1)\tLogin\n"
			<< "0)\tExit\n";

		if (selection != 0 && selection != 1) {
			cout << "You entered a wrong value. Enter an option (0-1): ";
		}
		else
			cout << "Enter an option (0-1): ";

		cin >> selection;
	} while (selection != 0 && selection != 1);

	return selection;
}

// Login by validating cutomer id
int customerLogin(Connection* conn, int customerId) {
	int found = 0;

	Statement* stmt = conn->createStatement();
	stmt->setSQL("BEGIN find_customer(:1, :2); END;");
	stmt->setInt(1, customerId);
	stmt->registerOutParam(2, Type::OCCIINT);
	stmt->executeUpdate();
	found = stmt->getInt(2);
	conn->terminateStatement(stmt);

	return found;
}

// Add the product to the cart
int addToCart(Connection* conn, ShoppingCart cart[]) {
	ShoppingCart shopCart;
	int i, 
		prodID = -1, 
		prodQTY = -1,
		prodNUM = 0, 
		selection;
	cout << "-------------- Add Products to Cart --------------" << endl;
	for (i = 0; i < 5; i++) {
		do {
			cout << "Enter the product ID: ";
			cin >> prodID;
			cout << isdigit(prodID);
			if (findProduct(conn, prodID) == 0) {
				cout << "The product does not exist. Try again..." << endl;
			}
		} while (findProduct(conn, prodID) == 0);
		cout << "Product Price: " << findProduct(conn, prodID) << endl;
		cout << "Enter the product Quantity: ";
		cin >> prodQTY;
		shopCart.product_id = prodID;
		shopCart.price = findProduct(conn, prodID);
		shopCart.quantity = prodQTY;
		cart[i] = shopCart;

		if (i == 4) {
			i = 5;
		}
		else {
			do {
				cout << "Enter 1 to add more products or 0 to checkout: ";
				cin >> selection;
			} while (selection != 0 && selection != 1);
		}
		if (selection == 0) {
			i = 5;
		}
		prodNUM++;
	}
	return prodNUM;
}

// Find product by product id
double findProduct(Connection* conn, int product_id) {
	double price = 0;
	Statement* stmt = conn->createStatement();
	stmt->setSQL("BEGIN find_product(:1, :2); END;");
	stmt->setInt(1, product_id);
	stmt->registerOutParam(2, OCCIDOUBLE);
	stmt->executeUpdate();
	price = stmt->getDouble(2);
	conn->terminateStatement(stmt);

	return price;
}

// Display products in the cart
void displayProducts(ShoppingCart cart[], int productCount) {
	double total = 0;
	cout << "------- Ordered Products ---------" << endl;
	for (size_t i = 0; i < productCount; ++i) {
		cout << "---Item " << i + 1 << endl;
		cout << "Product ID: " << cart[i].product_id << endl;
		cout << "Price: " << cart[i].price << endl;
		cout << "Quantity: " << cart[i].quantity << endl;
		total += (cart[i].price * cart[i].quantity);
	}
	cout << "----------------------------------\nTotal: " << total << endl;
}

// Checkout
int checkout(Connection* conn, ShoppingCart cart[], int customerId, int productCount) {
	int result = 0, newOrder = 0, i;
	char selection = '\0';
	do {
		cout << "Would you like to checkout ? (Y / y or N / n) ";
		cin >> selection;
		if (selection != 'Y' && selection != 'y' && selection != 'N' && selection != 'n') {
			cout << "Wrong input. Try again..." << endl;
		}
	} while (selection != 'Y' && selection != 'y' && selection != 'N' && selection != 'n');
	if (selection == 'N' || selection == 'n') {
		cout << "The order is cancelled." << endl;
	}
	else {
		Statement* stmt = conn->createStatement();
		stmt->setSQL("BEGIN add_order(:1, :2); END;");
		stmt->setInt(1, customerId);
		stmt->registerOutParam(2, Type::OCCIINT);
		stmt->executeUpdate();
		newOrder = stmt->getInt(2);
		for (i = 0; i < productCount; i++) {
			stmt->setSQL("BEGIN add_orderline(:1, :2, :3, :4, :5); END;");
			stmt->setInt(1, newOrder);
			stmt->setInt(2, i + 1);
			stmt->setInt(3, cart[i].product_id);
			stmt->setInt(4, cart[i].quantity);
			stmt->setDouble(5, cart[i].price);
			stmt->executeUpdate();
		}
		cout << "The order is successfully completed." << endl;
		conn->terminateStatement(stmt);
		result = 1;
	}
	return result;
}
