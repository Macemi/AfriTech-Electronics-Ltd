CREATE TABLE Afritech (
CustomerID INT,
CustomerName Text,
Region Text,
Age INT,
Income Numeric(10, 2),
CustomerType Text,
TransactionYear INT,
TranactionDATE Date,
ProductPurchased Text,
PurchasedAmount Numeric(10, 2),
ProductRecalled Boolean,
Competitor_x Text,
InteractionDate Date,
Platform Text,
PostType Text,
EngagementLikes INT,
EngagementShares INT,
EngagementComments INT,
UserFollowers INT,
InfluncerScore Numeric(10,2),
BrandMention Boolean,
CompetitorMention Boolean,
Sentiment Text,
CrisisEventTime Date,
FirstResponseTime Date,
ResolutionStatus Boolean,
NPSResponse INT

);

ALTER TABLE AFRITECH
RENAME COLUMN  PurchasedAmount TO PurchaseAmount

SELECT * FROM Afritech; 

SELECT
Region, Income
From Afritech;


CREATE TABLE CustomerData (
CustomerID INT PRIMARY KEY,
CustomerName Varchar(50),
Region Varchar(50),
Age INT,
Income Numeric(10, 2),
CustomerType Varchar(20)
);


SELECT * FROM CustomerData

CREATE TABLE TransactionData(
	TransactionID SERIAL PRIMARY KEY,
	CustomerID INT,
	TransactionYear VARCHAR(4),
	TransactionDate DATE,
	ProductPurchased VARCHAR(255),
	PurchaseAmount NUMERIC(10, 2),
	ProductRecalled BOOLEAN,
	Competitor_x VARCHAR(255),
	FOREIGN KEY (CustomerID) REFERENCES CustomerData(CustomerID)
	);

SELECT * FROM TransactionData;

CREATE TABLE SocialMedia(
	PostID SERIAL PRIMARY KEY,
	CustomerID INT,
	InteractionDate DATE,
	Platform VARCHAR(50),
	Posttype VARCHAR (50),
	EngagementLikes INT,
	EngagementShares INT,
	EngagementComments INT,
	UserFollowers INT,
	InfluencerScore Numeric(10,2),
	BrandMention BOOLEAN,
	CompetitorMention BOOLEAN,
	Sentiment VARCHAR(50),
	CrisisEventTime DATE,
	FirstResponseTime DATE,
	ResolutionStatus BOOLEAN,
	NPSResponse INT,
	FOREIGN KEY (CustomerID) REFERENCES CustomerData	
);


INSERT INTO CustomerData(CustomerID, CustomerName, Age, Region, Income, CustomerType)
SELECT DISTINCT CustomerID, CustomerName, Age, Region, Income, CustomerType
FROM afritech;

SELECT * FROM CustomerData;
SELECT * FROM TransactionData;
SELECT * FROM Socialmedia;


INSERT INTO TransactionData(CustomerID, TransactionYear, TransactionDate, ProductPurchased, PurchaseAmount, ProductRecalled, Competitor_x)
SELECT CustomerID, TransactionYear, TransactionDate, ProductPurchased, PurchaseAmount, ProductRecalled, Competitor_x
FROM afritech
WHERE TransactionDate IS NOT NULL;


INSERT INTO SocialMedia(CustomerID, InteractionDate, Platform, Posttype, EngagementLikes, EngagementShares, 
EngagementComments, UserFollowers, InfluencerScore, BrandMention, CompetitorMention, Sentiment,
CrisisEventTime, FirstResponseTime, ResolutionStatus, NPSResponse)

SELECT CustomerID, InteractionDate, Platform, Posttype, EngagementLikes, EngagementShares, 
EngagementComments, UserFollowers, InfluencerScore, BrandMention, CompetitorMention, Sentiment, CrisisEventTime, FirstResponseTime, ResolutionStatus, NPSResponse
FROM afritech
WHERE InteractionDate IS NOT NULL; 

Select count(*) FROM Customerdata;
Select count(*) FROM TransactionData;
Select count(*) FROM SocialMedia;


Select count(*) FROM Customerdata
WHERE Customerid is null;

-- EDA
SELECT MAX(AGE) AS Oldest,
       MIN(AGE) AS Youngest,
	   ROUND(Avg(AGE), 0) AS Average_age
FROM CustomerDATA;

SELECT
Region, count(*)
FROM Customerdata
GROUP BY Region
ORDER BY count(*) DESC;

SELECT customertype, COUNT(*)
FROM CustomerData
GROUP BY customertype;

SELECT ROUND(MAX(Income), 2) AS Maximum_income,
	   ROUND(MIN(Income), 2) AS Minimum_Income,
	   ROUND(AVG(Income), 2) AS Average_income
FROM Customerdata;

SELECT MAX(Purchaseamount) AS higest_price,
       MIN(Purchaseamount) AS lowest_price,
	   AVG(Purchaseamount) AS average_price
FROM transactiondata;

SELECT Productpurchased, count(*) AS PurchaseQuantity,
SUM(PurchaseAmount) AS TotalSales
From transactiondata
GROUP BY Productpurchased
ORDER BY TotalSales DESC;

-- WHAT ARE THE PRODUCT RECALL BEHAVIOUR
SELECT ProductRecalled, COUNT(*) AS RECALLED,
SUM(PURCHASEAMOUNT) AS Totalsales
From transactiondata
GROUP BY ProductRecalled
ORDER BY TotalSales DESC;

--What are the likes behavior per platform
SELECT platform, sum(EngagementLikes) AS TotalLikes,
AVG(EngagementLikes) AS Avg_Likes
FROM Socialmedia
GROUP BY Platform
ORDER BY TotalLikes desc;

--What are the Shares behavior per platform
SELECT platform, SUM(Engagementshares) AS Total_shares,
AVG(Engagementshares) AS Average_shares
FROM Socialmedia
Group BY platform
ORDER BY SUM(Engagementshares) DESC;

SELECT sentiment, COUNT(*) AS Sentiment_count
FROM SOCIALMEDIA
GROUP BY Sentiment
ORDER BY Sentiment_count desc;

SELECT Region, COUNT(*) AS NEGATIVE_COUNT
FROM socialmedia s
inner join customerdata c
ON s.customerid = c.customerid
WHERE s.sentiment = 'Negative'
Group by c.region
ORDER BY NEGATIVE_COUNT DESC;


-- Brand Mentions vs Competitor mentions
SELECT SUM(CASE
	    WHEN BrandMention = 'True' THEN 1
	    ELSE 0 
            END) AS BrandMentionCount,
	   SUM(CASE
	    WHEN CompetitorMention = 'True' THEN 1
	    ELSE 0 
            END) AS CompetitorMentionCount
FROM SocialMedia;

SELECT 
CAST(Firstresponsetime AS timestamp),
crisiseventtime
From Socialmedia
WHERE sentiment = 'Negative'
AND crisiseventtime IS NOT NULL
AND firstresponsetime IS NOT NULL 


SELECT AVG(DATE_PART('epoch', CAST(firstresponsetime AS timestamp) - CAST(crisiseventtime AS timestamp)) / 3600) AS averageresponsetimehours
FROM SocialMedia
WHERE Sentiment = 'Negative'
AND crisiseventtime IS NOT NULL
AND firstresponsetime IS NOT NULL 


