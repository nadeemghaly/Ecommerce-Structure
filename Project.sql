CREATE TABLE Users (
username varchar(20),
PRIMARY KEY(username),
password varchar(20),
first_name varchar(20),
last_name varchar(20),
email varchar(50)
);
CREATE TABLE User_mobile_numbers(
mobile_number varchar(20),
username varchar(20),
PRIMARY KEY(mobile_number,username),
FOREIGN KEY(username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE User_Adresses(
address varchar(100),
username varchar(20),
PRIMARY KEY(address,username),
FOREIGN KEY(username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Customer(
username varchar(20),
points int DEFAULT 0,
PRIMARY KEY(username),
FOREIGN KEY(username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Admins(
username varchar(20),
PRIMARY KEY(username),
FOREIGN KEY(username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Vendor(
username varchar(20),
activated bit default null ,
company_name varchar(20),
bank_acc_no varchar(20),
admin_username varchar(20),
PRIMARY KEY(username),
FOREIGN KEY(username) REFERENCES Users, --ON DELETE CASCADE ON UPDATE CASCADE, --shelna on delete
FOREIGN KEY(admin_username) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE GiftCard(
code varchar(10),
expiry_date datetime,
amount int,
username varchar(20),
PRIMARY KEY(code),
FOREIGN KEY(username) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Delivery_Person(
username varchar(20),
is_activated bit,
PRIMARY KEY(username),
FOREIGN KEY(username) REFERENCES USERS ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Credit_Card(
number varchar(20),
expiry_date date,
cvv_code varchar(4),
PRIMARY KEY(number)
);
CREATE TABLE Delivery(
id int IDENTITY,
type varchar(20),
time_duration int,
fees decimal(5,3),
username varchar(20),
PRIMARY KEY (id),
FOREIGN KEY (username) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Todays_Deals(
deal_id int IDENTITY,
deal_amount int,
expiry_date datetime,
admin_username varchar(20),
PRIMARY KEY(deal_id),
FOREIGN KEY(admin_username) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Offer(
offer_id INT IDENTITY,
offer_amount int,
expiry_date datetime,
PRIMARY KEY(offer_id)
);
CREATE TABLE Wishlist(
username varchar(20),
name varchar(20),
PRIMARY KEY(username,name),
FOREIGN KEY(username) REFERENCES Customer --ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Admin_Customer_Giftcard(
code varchar(10),
customer_name varchar(20),
admin_username varchar(20),
remaining_points int,
PRIMARY KEY(code, customer_name, admin_username),
FOREIGN KEY(code) REFERENCES Giftcard ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(customer_name) REFERENCES Customer,-- ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(admin_username) REFERENCES Admins,-- ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Customer_CreditCard(
customer_name varchar(20),
cc_number varchar(20),
PRIMARY KEY(customer_name,cc_number),
FOREIGN KEY(customer_name) REFERENCES Customer ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cc_number) REFERENCES Credit_Card-- ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Orders(
order_no int IDENTITY,
order_date date,
total_amount decimal(10,2),
cash_amount decimal(10,2),
credit_amount decimal(10,2),
payment_type varchar(10),
order_status varchar(30),
remaining_days int,
time_limit datetime,
Gift_Card_code_used varchar(10),
customer_name varchar(20),
delivery_id int,
creditCard_number varchar(20),
PRIMARY KEY(order_no),
FOREIGN KEY(Gift_Card_code_used) references Giftcard, --ON DELETE CASCADE ON UPDATE CASCADE
FOREIGN KEY(customer_name) references Customer ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(delivery_id) references Delivery, --ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(creditCard_number) references Credit_Card --ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Admin_Delivery_Order(
delivery_username varchar(20),
order_no int,
admin_username varchar(20),
delivery_window varchar(50),
PRIMARY KEY(delivery_username,order_no),
FOREIGN KEY(delivery_username) REFERENCES Delivery_Person,-- ON DELETE NO ACTION ON UPDATE CASCADE,  --on delete cascade
FOREIGN KEY(order_no) REFERENCES Orders,-- ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(admin_username) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Product(
serial_no int IDENTITY,
product_name varchar(20),
category varchar(20),
product_description text,
price decimal(10,2),
final_price decimal(10,2),
color varchar(20),
available bit DEFAULT 1,
rate int,
vendor_username varchar(20),
customer_username varchar(20),
customer_order_id int,
PRIMARY KEY(serial_no),
FOREIGN KEY(vendor_username) REFERENCES Vendor ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(customer_order_id) REFERENCES Orders-- ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE CustomerAddstoCartProduct(
serial_no int,
customer_name varchar(20),
PRIMARY KEY(serial_no,customer_name),
FOREIGN KEY(serial_no) REFERENCES Product ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(customer_name) REFERENCES Customer-- ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Todays_Deals_Product(
deal_id int,
serial_no int,
issue_date datetime, --need to add a trigger to set the issue date
PRIMARY KEY(deal_id,serial_no),
FOREIGN KEY(deal_id) REFERENCES Todays_Deals ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(serial_no) REFERENCES Product-- ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE offersOnProduct(
offer_id int,
serial_no int,
FOREIGN KEY(offer_id) REFERENCES Offer ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(serial_no) REFERENCES Product-- ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Customer_Question_Product(
serial_no int,
customer_name varchar(20),
question varchar(50),
answer text,
PRIMARY KEY(serial_no,customer_name),
FOREIGN KEY(serial_no) REFERENCES Product ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(customer_name) REFERENCES Customer-- ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Wishlist_Product(
username varchar(20),
wish_name varchar(20),
serial_no int,
PRIMARY KEY(username,wish_name,serial_no),
FOREIGN KEY(username,wish_name) REFERENCES Wishlist,-- ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(serial_no) REFERENCES Product-- ON DELETE CASCADE ON UPDATE CASCADE
);

GO
CREATE PROC customerRegister
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50)
AS
INSERT INTO Users(username,first_name,last_name,password,email)
VALUES(@username,@first_name,@last_name,@password,@email)
INSERT INTO Customer(username,points)
VALUES(@username,0)

GO
EXEC customerRegister 'ahmed.ashraf','ahmed','ashraf','pass123',' ahmed@yahoo.com'
GO

CREATE PROC vendorRegister
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50),
@company_name varchar(20),
@bank_acc_no varchar(20)
AS
INSERT INTO Users(username,first_name,last_name,password,email)
VALUES(@username,@first_name,@last_name,@password,@email)
INSERT INTO Vendor(username,activated,company_name,bank_acc_no)
VALUES(@username,0,@company_name,@bank_acc_no)

GO 
EXEC vendorRegister 'eslam.mahmod','eslam','mahmod','pass1234','hopa@gmail.com','Market','132132513' 
GO


GO

CREATE PROC userLogin
@username varchar(20),
@password varchar(20),
@success bit OUTPUT,
@type int OUTPUT
AS
SET @success=0

SELECT @success=1
FROM Users
WHERE username = @username and @password=password

SET @type=-1
if (@success=1)
BEGIN
SELECT @type=0
FROM customer
WHERE username = @username 

SELECT @type=1
FROM Vendor
WHERE username = @username 

SELECT @type=2
FROM Admins
WHERE username = @username 

SELECT @type=3
FROM Delivery_Person
WHERE username = @username 

END

GO

Declare @type int  
Declare @success bit 
EXEC userLogin 'ahmed.ashraf','pass',@success output,@type output
print(@success)
print(@type)
GO

CREATE PROC addMobile
@username varchar(20),
@mobile_number varchar(20)
AS
INSERT INTO User_mobile_numbers(username,mobile_number)
VALUES(@username,@mobile_number)

select*
from User_mobile_numbers
GO

EXEC addMobile 'ahmed.ashraf','01111211122'
EXEC addMobile 'ahmed.ashraf','0124262652'
select *
FROM User_mobile_numbers
GO

CREATE PROC addAddress
@username varchar(20),
@address varchar(100)
AS
INSERT INTO User_Adresses(address,username)
VALUES(@address,@username)

GO
EXEC addAddress 'ahmed.ashraf','nasr city'
SELECT *
FROM User_Adresses
GO

CREATE PROC showProducts  
AS
SELECT product_name,product_description,price,final_price,color
FROM Product
WHERE available=1

GO

EXEC showProducts
GO

CREATE PROC ShowProductsbyPrice
AS
SELECT product_name,product_description,price,color
FROM Product
WHERE available=1
ORDER BY final_price

GO
EXEC ShowProductsbyPrice
GO
CREATE PROC searchbyname
@text varchar(20)
AS
SELECT product_name,product_description,price,final_price,color
FROM Product
WHERE product_name like CONCAT('%',@text,'%') AND available=1;

GO
EXEC searchbyname 'Blue'
DROP PROC searchbyname
select *
FROM Product
GO


CREATE PROC AddQuestion
@serial int,
@customer varchar(20),
@Question varchar(50)
AS
INSERT INTO Customer_Question_Product(serial_no,customer_name,question)
VALUES(@serial,@customer,@Question)

GO

EXEC AddQuestion 1,'ahmed.ashraf','size?'
SELECT *
FROM Customer_Question_Product
GO

CREATE PROC addToCart
@customername varchar(20),
@serial int
AS
if exists( SELECT *
FROM Product
WHERE available=1)
BEGIN
INSERT INTO CustomerAddstoCartProduct(customer_name,serial_no)
VALUES(@customername,@serial)
END
GO
--EXEC addToCart 'ahmed.ashraf',1
--EXEC addToCart 'ahmed.ashraf',2  --moshkela momken ne3mel trigger w roll back w bet3

CREATE PROC removefromCart
@customername varchar(20),
@serial int
AS
DELETE FROM CustomerAddstoCartProduct
WHERE customer_name=@customername and serial_no=@serial

GO

--EXEC removefromCart 'ahmed.ashraf','1'


CREATE PROC createWishlist
@customername varchar(20),
@name varchar(20)
AS
INSERT INTO Wishlist(username,name)
VALUES(@customername,@name)

GO

--EXEC createWishlist 'ahmed.ashraf','fashion'

CREATE PROC AddtoWishlist
@customername varchar(20),
@wishlistname varchar(20),
@serial int
AS
INSERT INTO Wishlist_Product(username,wish_name,serial_no)
VALUES(@customername,@wishlistname,@serial)

GO
--EXEC AddtoWishlist 'ammar.yasser','fashion',1
--EXEC AddtoWishlist 'ahmed.ashraf','fashion',2  


CREATE PROC removefromWishlist
@customername varchar(20),
@wishlistname varchar(20),
@serial int
AS
DELETE FROM Wishlist_Product
WHERE username=@customername and wish_name=@wishlistname and serial_no = @serial
GO

--EXEC removefromWishlist 'ammar.yasser','fashion',1


CREATE PROC showWishlistProduct
@customername varchar(20),
@name varchar(20)
AS
SELECT P.product_name,p.product_description,p.price,p.final_price,p.color
FROM Wishlist_Product W inner join Product P
ON W.serial_no=P.serial_no
WHERE W.username=@customername and w.wish_name=@name
GO

--EXEC showWishlistProduct 'ahmed.ashraf','fashion'


CREATE PROC viewMyCart
@customer varchar(20)
AS
SELECT P.product_name,p.product_description,p.price,p.final_price,p.color
FROM CustomerAddstoCartProduct W inner join Product P
ON W.serial_no=P.serial_no
WHERE W.customer_name=@customer

GO
EXEC viewMyCart 'ahmed.ashraf'
GO

CREATE PROC calculatepriceOrder
@customername varchar(20),
@sum decimal(10,2) output
AS
SELECT @sum= SUM(P.final_price)
FROM CustomerAddstoCartProduct W inner join Product P
ON W.serial_no=P.serial_no
WHERE W.customer_name=@customername

declare @sum decimal(10,2)
EXEC calculatepriceOrder 'ahmed.ashraf',@sum output
print(@sum)
GO

CREATE PROC productsinorder  
@customername varchar(20),
@orderID int

AS
select P.product_name
FROM CustomerAddstoCartProduct CP inner join PRODUCT P ON CP.serial_no=P.serial_no
WHERE CP.customer_name=@customername


DELETE FROM CustomerAddstoCartProduct
WHERE customer_name<>@customername and serial_no in(select CustomerAddstoCartProduct.serial_no from CustomerAddstoCartProduct where @customername=customer_name)

UPDATE Product
SET available =0
WHERE  serial_no in(select serial_no from CustomerAddstoCartProduct where @customername=customer_name)

GO

CREATE PROC emptyCart
@customername varchar(20)
AS
DELETE FROM CustomerAddstoCartProduct
WHERE customer_name=@customername
EXEC viewMyCart @customername   --katebha fel testcases idk what it means

GO
CREATE PROC makeOrder 
@customername varchar(20)
AS
DECLARE @sum decimal(10,2)
EXEC calculatepriceOrder @sum
INSERT INTO Orders(customer_name,order_date,total_amount)
VALUES(@customername,CURRENT_TIMESTAMP,@sum)
EXEC emptyCart @customername

EXEC makeOrder 'ahmed.ashraf'

GO

CREATE PROC cancelOrder
@orderid int
AS
IF EXISTS( SELECT * FROM Orders WHERE order_no=@orderid and (order_status like '%not processed%' or  order_status like '%in process%'))
BEGIN
IF EXISTS(SELECT *
	FROM Orders O inner join GiftCard G on O.Gift_Card_code_used=G.code
	WHERE G.expiry_date<CURRENT_TIMESTAMP)
BEGIN
declare @usedpoints int
declare @customer varchar(20)
declare @code varchar(10)
declare @admin varchar(20)

SELECT @usedpoints=total_amount-cash_amount-credit_amount, @customer=customer_name, @code=Gift_Card_code_used
FROM Orders
WHERE order_no=@orderid

select @admin=username
FROM GiftCard
WHERE code=@code

UPDATE Customer
SET points=points+@usedpoints
WHERE username=@customer

UPDATE Admin_Customer_Giftcard
SET remaining_points=remaining_points+@usedpoints
WHERE @code=code and customer_name=@customer and admin_username=@admin

END

UPDATE Product
SET customer_username=null,
	customer_order_id=null,
	available=1
where customer_order_id=@orderid

DELETE FROM Admin_Delivery_Order
WHERE order_no=@orderid

DELETE FROM Orders
Where order_no=@orderid

END

GO


CREATE PROC returnProduct
@serialno int,
@orderid int
AS

if exists(select * 
		  FROM Orders
		  WHERE Gift_Card_code_used=null and order_no=@orderid)
BEGIN

UPDATE ORDERS
SET total_amount=0
WHERE order_no=@orderid

UPDATE Product
SET available=1,
	rate=null,
	customer_username=null,
	customer_order_id=null
WHERE serial_no=@serialno

END
ELSE if exists(select * 
		  FROM Orders O inner join GiftCard G on O.Gift_Card_code_used=G.code
		  WHERE Gift_Card_code_used<>null and order_no=@orderid and expiry_date>CURRENT_TIMESTAMP)
BEGIN
declare @giftamount int
declare @giftcode varchar(10)
declare @adminn varchar(20)
declare @customerr varchar(20)


SELECT @customerr=O.customer_name,@giftamount=total_amount-cash_amount-credit_amount, @giftcode=Gift_Card_code_used, @adminn=G.username
FROM Orders O inner join GiftCard G ON O.Gift_Card_code_used=G.code
WHERE order_no=@orderid

UPDATE ORDERS
SET total_amount=0
WHERE order_no=@orderid

UPDATE Product
SET available=1,
	customer_username=null,
	rate=null,
	customer_order_id=null
WHERE serial_no=@serialno

UPDATE Admin_Customer_Giftcard
SET remaining_points=remaining_points+@giftamount
WHERE code=@giftcode and customer_name=@customerr and admin_username=@adminn

UPDATE Customer
SET points=points+@giftamount
WHERE username=@customerr

END
ELSE if exists(select * 
		  FROM Orders O inner join GiftCard G on O.Gift_Card_code_used=G.code
		  WHERE Gift_Card_code_used<>null and order_no=@orderid and expiry_date<CURRENT_TIMESTAMP)
BEGIN

UPDATE ORDERS
SET total_amount=0
WHERE order_no=@orderid

UPDATE Product
SET available=1,
	customer_username=null,
	rate=null,
	customer_order_id=null
WHERE serial_no=@serialno

END

SELECT *
FROM Orders
WHERE order_no=@orderid

GO

CREATE PROC ShowproductsIbought
@customername varchar(20)
AS 
SELECT serial_no,product_name,category,product_description,price,final_price,color
FROM Product
WHERE customer_username=@customername

GO

CREATE PROC rate
@serialno int,
@rate int,
@customername varchar(20)
AS
UPDATE Product
SET rate=@rate
WHERE serial_no=@serialno and customer_username = @customername

EXEC rate 2,3,'ahmed.ashraf'
GO


CREATE PROC SpecifyAmount
@customername varchar(20),
@orderID int,
@cash decimal(10,2),
@credit decimal(10,2)
AS

IF (@cash<>0 and @credit<>0)
BEGIN
RAISERROR('you cant use both cash and credit in the same order',16,1)
END

DECLARE @total decimal(10,2)
SELECT @total=total_amount
FROM Orders
WHERE @customername=customer_name and order_no=@orderID

declare @neededpoints int
SET @neededpoints=@total-(@cash+@credit)

declare @code varchar(10)
DECLARE @points int
declare @admin varchar(20)

SELECT @points=min(remaining_points)
FROM Admin_Customer_Giftcard
WHERE @customername = customer_name and remaining_points>=@neededpoints

SELECT @code=code, @admin=admin_username
FROM Admin_Customer_Giftcard
WHERE @customername = customer_name and @points=remaining_points

IF (@total>@cash+@credit+@points)
BEGIN
RAISERROR('you dont have enough points to complete this transaction',16,1)
END

ELSE
BEGIN

if(@cash=0)
BEGIN
UPDATE Orders
SET payment_type='credit'
WHERE order_no=@orderID and customer_name=@customername
END
ELSE
BEGIN
UPDATE Orders
SET payment_type='cash'
WHERE order_no=@orderID and customer_name=@customername
END

UPDATE Orders
SET cash_amount=@cash,
	credit_amount=@credit,
	Gift_Card_code_used=@code	
WHERE order_no=@orderID and customer_name=@customername

UPDATE Admin_Customer_Giftcard
SET remaining_points=@points-@neededpoints
WHERE @code=code and @customername=customer_name and @admin=admin_username

UPDATE Customer
SET points=points-@neededpoints
WHERE username=@customername
END

GO

CREATE PROC AddCreditCard
@creditcardnumber varchar(20),
@expirydate date,
@cvv varchar(4),
@customername varchar(20)
AS
INSERT INTO Credit_Card(number,expiry_date,cvv_code)
VALUES(@creditcardnumber,@expirydate,@cvv)
INSERT INTO Customer_CreditCard(customer_name,cc_number)
VALUES(@customername,@creditcardnumber)

GO



CREATE PROC ChooseCreditCard
@creditcard varchar(20),
@orderid int
AS
UPDATE Orders
SET creditCard_number=@creditcard
WHERE order_no=@orderid

GO

CREATE PROC vewDeliveryTypes
AS
SELECT DISTINCT(type),time_duration as 'duration in days', fees
FROM Delivery


GO

CREATE PROC specifydeliverytype
@orderID int,
@deliveryID int
AS

DECLARE @time_window int
SELECT @time_window=time_duration
FROM Delivery
WHERE @deliveryID=id

UPDATE Orders
SET delivery_id=@deliveryID, remaining_days=@time_window
WHERE order_no=@orderid


GO
CREATE PROC trackRemainingDays
@orderid int,
@customername varchar(20),
@days int OUTPUT

AS
select remaining_days=time_duration-DATEDIFF(day,order_date, CURRENT_TIMESTAMP)
FROM Orders O inner join Delivery D on O.delivery_id=D.id
WHERE O.order_no=@orderid

select @days=remaining_days
FROM Orders O 
WHERE O.order_no=@orderid

GO
--DECLARE @days int
--EXEC trackRemainingDays 6,'ahmed.ashraf',@days OUTPUT


CREATE PROC recommend
@customername VARCHAR(20)
AS
SELECT *
FROM Product
WHERE serial_no IN ((SELECT TOP 3 Nour.serial_no
FROM Product Nour INNER JOIN Wishlist_Product WishNado ON Nour.serial_no = WishNado.serial_no
WHERE Nour.category IN (SELECT TOP 3 Nour.category
FROM CustomerAddstoCartProduct Cart INNER JOIN Product Nour ON Cart.serial_no = Nour.serial_no
WHERE customer_name = @customername
GROUP BY Nour.category
ORDER BY COUNT(*) DESC) 
AND
WishNado.username <> @customername 
AND
Nour.serial_no NOT IN (SELECT serial_no
FROM CustomerAddstoCartProduct
WHERE customer_name = @customername)
GROUP BY Nour.serial_no
ORDER BY COUNT(*) DESC 
)
UNION
(SELECT TOP 3 Nour.serial_no
FROM Product Nour INNER JOIN Wishlist_Product WishNado ON Nour.serial_no = WishNado.serial_no
WHERE WishNado.username IN (SELECT TOP 3 customer_name
FROM CustomerAddstoCartProduct
WHERE serial_no IN (SELECT serial_no
FROM CustomerAddstoCartProduct
WHERE customer_name = @customername) AND customer_name <> @customername
GROUP BY customer_name
ORDER BY COUNT(*) DESC)AND WishNado.username <> @customername AND Nour.serial_no 
NOT IN (
SELECT serial_no
FROM CustomerAddstoCartProduct
WHERE customer_name = @customername) GROUP BY Nour.serial_no ORDER BY COUNT(*) DESC)
)
				 
GO
--EXEC recommend 'ahmed.ashraf'

GO

CREATE PROC postProduct
@vendorUsername varchar(20),
@product_name varchar(20),
@category varchar(20),
@product_description text,
@price decimal(10,2),
@color varchar(20)
as
if exists(select *
FROM Vendor
WHERE username=@vendorUsername and activated=1)
BEGIN
INSERT INTO Product(vendor_username,product_name,category,product_description,price,final_price,color)
VALUES(@vendorUsername,@product_name,@category,@product_description,@price,@price,@color)
END

GO


CREATE PROC vendorviewProducts
@vendorname varchar(20)
AS
SELECT product_name
FROM Product
WHERE vendor_username=@vendorname


GO
CREATE PROC EditProduct   --fel test cases beydkhl 3 input bas
@vendorname varchar(20),
@serialnumber int,
@product_name varchar(20),
@category varchar(20),
@product_description text,
@price decimal(10,2),
@color varchar(20)
AS
UPDATE Product
SET vendor_username=@vendorname,
	product_name=@product_name,
	category=@category,
	product_description=@product_description,
	final_price=@price,
	color=@color
WHERE serial_no=@serialnumber

GO

CREATE PROC deleteProduct
@vendorname varchar(20),
@serialnumber int
AS
DELETE FROM Product
WHERE vendor_username=@vendorname and serial_no=@serialnumber

GO


CREATE PROC viewQuestions
@vendorname varchar(20)
AS
SELECT C.*
FROM Customer_Question_Product C inner join Product P
ON C.serial_no=P.serial_no
WHERE p.vendor_username=@vendorname

GO

CREATE PROC answerQuestions
@vendorname varchar(20),
@serialno int,
@customername varchar(20),
@answer text
AS
UPDATE Customer_Question_Product
SET answer=@answer
WHERE serial_no=@serialno and customer_name=@customername

GO

CREATE PROC addOffer
@offeramount int,
@expiry_date datetime
AS
INSERT INTO Offer(offer_amount,expiry_date)
VALUES(@offeramount,@expiry_date)

GO

CREATE PROC checkOfferonProduct
@serial int,
@activeoffer bit OUTPUT
AS
SET @activeoffer=0
SELECT @activeoffer=1
FROM offer O inner join offersOnProduct OP
ON O.offer_id=OP.offer_id
WHERE serial_no=@serial and expiry_date>CURRENT_TIMESTAMP

GO
CREATE PROC checkandremoveExpiredoffer   --revise
@offerid int
AS
DECLARE @serial int
DECLARE @amount int
while exists(SELECT *
FROM offersOnProduct OP inner join Offer O ON OP.offer_id=O.offer_id
WHERE O.offer_id=@offerid and O.expiry_date>CURRENT_TIMESTAMP
)
BEGIN
SELECT @serial=OP.serial_no, @amount=O.offer_amount
FROM offersOnProduct OP inner join Offer O on OP.offer_id=O.offer_id
WHERE O.offer_id=@offerid

UPDATE Product
SET final_price=final_price+@amount
WHERE serial_no=@serial

DELETE FROM offersOnProduct
WHERE serial_no=@serial and offer_id=@offerid

END
DELETE FROM Offer
WHERE offer_id=@offerid and expiry_date>CURRENT_TIMESTAMP

GO

CREATE PROC applyOffer
@vendorname varchar(20),
@offerid int,
@serial_no int
AS
if exists(SELECT *
			FROM offersOnProduct OP inner join Product P on OP.serial_no=P.serial_no inner join Offer O ON OP.offer_id=O.offer_id
			WHERE p.serial_no=@serial_no and O.expiry_date>CURRENT_TIMESTAMP)
BEGIN
PRINT('The product has an active offer')
END
else
BEGIN 
declare @offeramount int
SELECT @offeramount=offer_amount
FROM Offer
WHERE offer_id=@offerid

UPDATE Product
SET final_price=price-@offeramount
WHERE vendor_username=@vendorname and serial_no=@serial_no

END




GO
CREATE PROC activateVendors
@admin_username varchar(20),
@vendor_username varchar(20)
AS
UPDATE Vendor
SET admin_username=@admin_username,
	activated=1
WHERE username=@vendor_username
GO
EXEC activateVendors 'hana.aly','eslam.mahmod'
GO

CREATE PROC inviteDeliveryPerson
@delivery_username varchar(20),
@delivery_email varchar(50)
AS
INSERT INTO Users(username,email)
VALUES(@delivery_username,@delivery_email)
INSERT INTO Delivery_Person(is_activated,username)
VALUES(0,@delivery_username)

GO

CREATE PROC reviewOrders
AS
SELECT *
FROM Orders

GO

CREATE PROC updateOrderStatusInProcess
@order_no int
AS
UPDATE Orders
SET order_status='In process'
WHERE order_no=@order_no

GO

CREATE PROC addDelivery
@delivery_type varchar(20),
@time_duration int,
@fees decimal(5,3),
@admin_username varchar(20)
AS
INSERT INTO Delivery(type,time_duration,fees,username)
VALUES(@delivery_type,@time_duration,@fees,@admin_username)
GO
--exec addDelivery 'pick-up',7,10.00,'hana.aly'

CREATE PROC assignOrdertoDelivery
@delivery_username varchar(20),
@order_no int,
@admin_username varchar(20)
AS
INSERT INTO Admin_Delivery_Order(delivery_username, order_no, admin_username)
VALUES(@delivery_username,@order_no,@admin_username)

GO

CREATE PROC createTodaysDeal
@deal_amount int,
@admin_username varchar(20),
@expiry_date datetime
AS
INSERT INTO Todays_Deals(deal_amount,admin_username,expiry_date)
VALUES(@deal_amount,@admin_username,@expiry_date)

GO

CREATE PROC checkTodaysDealOnProduct
@serial_no int,
@activeDeal BIT OUTPUT
AS
SELECT @activeDeal=1
FROM Todays_Deals_Product p1 inner join Todays_Deals p11 on p1.deal_id=p11.deal_id
WHERE serial_no=@serial_no and expiry_date<CURRENT_TIMESTAMP

GO

CREATE PROC addTodaysDealOnProduct
@deal_id int,
@serial_no int
AS
INSERT INTO Todays_Deals_Product(deal_id,serial_no,issue_date)
VALUES(@deal_id,@serial_no,CURRENT_TIMESTAMP)
DECLARE @discountprice int

SELECT @discountprice=deal_amount
FROM Todays_Deals
WHERE deal_id=@deal_id

update Product
SET final_price = final_price-@discountprice
WHERE serial_no=@serial_no

GO

CREATE PROC removeExpiredDeal --revise
@deal_id int 
AS
DECLARE @serial int
DECLARE @amount int
while exists(SELECT *
FROM Todays_Deals_Product TDP inner join Todays_Deals TD ON TDP.deal_id=TD.deal_id
WHERE TD.deal_id=@deal_id and TD.expiry_date<CURRENT_TIMESTAMP
)
BEGIN
SELECT @serial=TDP.serial_no, @amount=deal_amount
FROM Todays_Deals TD inner join Todays_Deals_Product TDP on TD.deal_id=TDP.deal_id
WHERE TD.deal_id=@deal_id

UPDATE Product
SET final_price=final_price+@amount
WHERE serial_no=@serial

DELETE FROM Todays_Deals_Product
WHERE serial_no=@serial and deal_id=@deal_id
END

DELETE FROM Todays_Deals
WHERE @deal_id = deal_id and expiry_date<CURRENT_TIMESTAMP

GO

CREATE PROC createGiftCard
@code varchar(10),
@expiry_date datetime,
@amount int,
@admin_username varchar(20)

AS

INSERT INTO GiftCard(code,expiry_date,amount,username)
VALUES(@code,@expiry_date,@amount,@admin_username)
GO
--exec createGiftCard 'G104','2019-12-30',200,'hana.aly'

CREATE PROC removeExpiredGiftCard
@code varchar(10)
AS
DECLARE @points int
declare @customer varchar(20)
declare @admin varchar(20)
select @points= A.remaining_points, @admin=A.admin_username, @customer=A.customer_name
FROM GiftCard G inner join Admin_Customer_Giftcard A on G.code=A.code
WHERE g.expiry_date<CURRENT_TIMESTAMP

DELETE FROM Admin_Customer_Giftcard
WHERE customer_name=@customer and admin_username=@admin and code=@code

DELETE FROM GiftCard
WHERE code=@code

UPDATE Customer
SET points=points-@points 
WHERE username=@customer

GO

CREATE PROC checkGiftCardOnCustomer
@code varchar(10),
@activeGiftCard BIT OUTPUT
AS
select @activeGiftCard=1
FROM Admin_Customer_Giftcard A inner join GiftCard G on A.code=G.code
WHERE A.code=@code and G.expiry_date>CURRENT_TIMESTAMP

GO

CREATE PROC giveGiftCardtoCustomer
@code varchar(10),
@customer_name varchar(20),
@admin_username varchar(20)

AS 
DECLARE @remainingpoints int
SELECT @remainingpoints=amount
FROM GiftCard
WHERE code=@code

INSERT INTO Admin_Customer_Giftcard (code,customer_name,admin_username,remaining_points)
VALUES (@code,@customer_name,@admin_username,@remainingpoints)

UPDATE Customer
SET points=points+@remainingpoints
WHERE username=@customer_name
go




CREATE PROC acceptAdminInvitation 
@delivery_username varchar(20)
AS 
UPDATE Delivery_Person
SET is_activated = 1 
WHERE @delivery_username = delivery_username

GO



CREATE PROC deliveryPersonUpdateInfo
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50)

AS

UPDATE Users
SET first_name=@first_name,
	last_name=@last_name,
	password=@password,
	email=@email
WHERE username=@username
GO

CREATE PROC viewmyorders
@deliveryperson VARCHAR(20)
AS
SELECT O.order_no,O.total_amount,O.cash_amount,O.credit_amount,O.payment_type,O.order_status,O.remaining_days,o.time_limit,o.customer_name,o.delivery_id,o.creditCard_number,o.order_date,o.Gift_Card_code_used
FROM Orders O inner join Admin_Delivery_Order D on O.delivery_id=D.order_no
WHERE delivery_username=@deliveryperson
GO
--exec viewmyorders 'mohamed.tamer'

CREATE PROC specifyDeliveryWindow
@delivery_username varchar(20),
@order_no int,
@delivery_window varchar(50)
AS
UPDATE Admin_Delivery_Order
SET delivery_window = @delivery_window
WHERE delivery_username=@delivery_username and order_no=@order_no

go

CREATE PROC updateOrderStatusOutforDelivery
@order_no int

AS

UPDATE Orders
SET order_status = 'Out For Delivery'
WHERE @order_no = order_no

GO

CREATE PROC updateOrderStatusDelivered
@order_no int

AS

UPDATE Orders
SET order_status = 'Delivered'
WHERE order_no=@order_no

GO
INSERT INTO Users (username,first_name,last_name,password,email)
Values('hana.aly','hana','aly','pass1','hana.aly@guc.edu.eg')

INSERT INTO Users (username,first_name,last_name,password,email)
Values('ammar.yasser','ammar','yasser', 'pass4' ,'ammar.yasser@guc.edu.eg')

INSERT INTO Users (username,first_name,last_name,password,email)
Values('nada.sharaf','nada','sharaf','pass7','nada.sharaf@guc.edu.eg')

INSERT INTO Users (username,first_name,last_name,password,email)
Values('hadeel.adel','hadeel','adel','pass13','hadeel.adel@guc.edu.eg')

INSERT INTO Users (username,first_name,last_name,password,email)
Values('mohamed.tamer','mohamed','tamer','pass16','mohamed.tamer@guc.edu.eg')

INSERT INTO Admins (username)
Values('hana.aly')

INSERT INTO Admins (username)
Values('nada.sharaf')

INSERT INTO Customer(username,points)
Values('ammar.yasser',15)


INSERT INTO Vendor Values('hadeel.adel','1','Dello','47449349234','hana.aly')

INSERT INTO Delivery_Person Values ('mohamed.tamer',1)

Insert into User_Adresses Values('New Cairo','hana.aly')
Insert into User_Adresses Values('Heliopolis','hana.aly')

Insert into User_mobile_numbers Values(0111111111,'hana.aly')
Insert into User_mobile_numbers Values(1211555411,'hana.aly')

INSERT INTO Credit_Card(number,expiry_date,cvv_code)
Values ('4444-5555-6666-8888', '2028-10-19', '232')


INSERT INTO Delivery (type,time_duration,fees)
VALUES ('pick-up',7,10)
INSERT INTO Delivery (type,time_duration,fees)
VALUES ('regular',14,30)
INSERT INTO Delivery (type,time_duration,fees)
VALUES ('speedy',1,50)

INSERT INTO Product (product_name,category,product_description,price,final_price,color,available,rate,vendor_username)
VALUES ('Bag','Fashion','backbag',100,100,'yellow',1,0,'hadeel.adel')


INSERT INTO Product (product_name,category,product_description,price,final_price,color,available,rate,vendor_username)
VALUES ('Blue pen','Stationary','useful pen',10,10,'Blue',1,0,'hadeel.adel')

INSERT INTO Product (product_name,category,product_description,price,final_price,color,available,rate,vendor_username)
VALUES ('Blue pen','Stationary','useful pen',10,10,'Blue',0,0,'hadeel.adel')




INSERT INTO Todays_Deals (deal_amount,admin_username,expiry_date)
VALUES (30.00,'hana.aly','2019-11-30')
INSERT INTO Todays_Deals (deal_amount,admin_username,expiry_date)
VALUES (40,'hana.aly','2019-11-18')
INSERT INTO Todays_Deals (deal_amount,admin_username,expiry_date)
VALUES (50,'hana.aly','2019-12-12')

INSERT INTO offer (offer_amount,expiry_date)
VALUES (50,'2019-11-30')

INSERT INTO Wishlist (username,name)
VALUES ('ammar.yasser','fashion')



--INSERT INTO Wishlist_Product(username,wish_name,serial_no)    --mafeesh serial number 2
--VALUES ('ammar.yasser','fashion',2)
INSERT INTO Wishlist_Product(username,wish_name,serial_no)
VALUES ('ammar.yasser','fashion',2)

INSERT INTO CustomerAddstoCartProduct (serial_no,customer_name)
Values(1,'ammar.yasser')


INSERT INTO Customer_CreditCard (customer_name,cc_number)
VALUES ('ammar.yasser','4444-5555-6666-8888')



