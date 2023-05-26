use AdventureWorks2012;
go

-- 1
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT * FROM Production.WorkOrder

-- 2
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
select * from Production.WorkOrder where WorkOrderID=1234

-- 3.1
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT * FROM Production.WorkOrder
WHERE WorkOrderID between 10000 and 10010

--3.2
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT * FROM Production.WorkOrder
WHERE WorkOrderID between 1 and 72591

--4
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT * FROM Production.WorkOrder
WHERE StartDate = '2007-06-25'

--5
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
CREATE INDEX idx_ProductID ON Production.WorkOrder(ProductID)
SELECT * FROM Production.WorkOrder WHERE ProductID = 757

--6.1
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
CREATE INDEX idx_product_id_covered ON Production.WorkOrder(ProductID) include (StartDate)
SELECT WorkOrderID, StartDate FROM Production.WorkOrder
WHERE ProductID = 757

--6.2
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT WorkOrderID, StartDate FROM Production.WorkOrder
WHERE ProductID = 945

--6.3
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT WorkOrderID FROM Production.WorkOrder
WHERE ProductID = 945 AND StartDate = '2006-01-04'

--7
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
CREATE INDEX idx_startDate ON Production.WorkOrder(StartDate)
SELECT WorkOrderID, StartDate FROM Production.WorkOrder
WHERE ProductID = 945 AND StartDate = '2006-01-04'

--8
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
CREATE INDEX idx_both ON Production.WorkOrder(ProductID, StartDate)
SELECT WorkOrderID, StartDate FROM Production.WorkOrder
WHERE ProductID = 945 AND StartDate = '2006-01-04'