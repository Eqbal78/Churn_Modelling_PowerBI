use PowerBi

select * from Churn_Modelling

select * from Churn_Modelling where IsActiveMember = 1


alter function GetDetailsFromCountry(@country varchar(225),@gender varchar(25))
returns table
as
	return select COUNT(CustomerId) as TotalCustomer , Geography from Churn_Modelling where Geography = @country and Gender = @gender group by Geography 

select * from GetDetailsFromCountry('Spain','Male')


-----------------------------------------------------------------------------------------------


alter function getEmpDetails (@CustomerID int)
returns @emp table(
Surname varchar(225),
Gender varchar(25),
Age int,
IsActiveMember int
)
as
begin
declare @data int
	set @data = (select IsActiveMember from Churn_Modelling  where CustomerId = @CustomerID)
	if(@data = 1)
	begin
		insert into @emp select Surname,Gender,Age,IsActiveMember from Churn_Modelling where CustomerId = @CustomerID 
		
	end
	else
	begin
		insert into @emp select Surname,Gender,Age,IsActiveMember from Churn_Modelling where CustomerId = @CustomerID and IsActiveMember = 0
	end
	return 
end

select * from getEmpDetails (15701354)


---------------------------------------------------------------------------


alter function getDetails01(@CustomerID int)
returns table
as 
	return select Surname,Gender,Age,IsActiveMember from Churn_Modelling where CustomerId = @CustomerID


alter procedure Sp_GetData(@CustomerID int)
as 
begin
	declare @Active int
	set @Active = (select IsActiveMember from Churn_Modelling where CustomerId = @CustomerID)
    if (@Active > 0)
	begin
		select * from getDetails01(@CustomerID)
    end
	else
	begin	
		PRINT 'Please!!.. Active the Member';
	end
end

exec Sp_GetData 156319304

select * from Churn_Modelling


--------------------------------------------------------------------------------------------


create function getBalanceDetails(@CustomerID int)
returns table
as 
	return select Surname,Gender,Age,Balance from Churn_Modelling where CustomerId = @CustomerID


alter procedure Sp_GetBalanceData(@CustomerID int)
as 
begin
	declare @Active int
	set @Active = (select IsActiveMember from Churn_Modelling where CustomerId = @CustomerID)
    if (@Active > 0)
	begin
		select * from getBalanceDetails(@CustomerID)
    end
	else
	begin	
		PRINT 'Balance is Zero';
	end
end

exec Sp_GetBalanceData 15737888


------------ Cursor ------------------------


DECLARE @name varchar(225)  
DECLARE @salary money  
DECLARE @Gender varchar(225)
DECLARE @Age int
DECLARE @country varchar(225)
  
DECLARE EMP_CURSOR CURSOR  
LOCAL  FORWARD_ONLY  FOR  
SELECT Surname,EstimatedSalary,Gender,Age,Geography FROM Churn_Modelling 
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO @name,@salary,@Gender,@Age,@country 
WHILE @@FETCH_STATUS = 0  
BEGIN  
PRINT  'Surname: ' + CAST(@name AS varchar)+  '  EstimatedSalary '+CAST(@salary AS varchar) +'  Gender '  +CAST(@Gender AS varchar)  +  '  Age ' +CAST(@Age AS varchar)+  '  Geography ' +CAST(@country AS varchar)  
FETCH NEXT FROM EMP_CURSOR INTO  @name,@salary,@Gender,@Age,@country  
END  
CLOSE EMP_CURSOR
DEALLOCATE EMP_CURSOR


------------------------- View ------------------------------------------------------


alter view Churn_Modelling01
as
select CustomerId,Surname,Gender,Age,IsActiveMember,EstimatedSalary from Churn_Modelling

select * from Churn_Modelling01


------------------- Transaction ------------------------------------


begin transaction
insert into Churn_Modelling values
(100001,1002,'Romanoff',3004,'Spain','Female',20,3,0,1,1,1,5463214,1)
update Churn_Modelling set Geography = 'France' where CustomerId = 100001
commit

begin transaction
delete from Churn_Modelling where CustomerId = 100001
rollback;


--------------------- Sub Query --------------------------------------

select * from Churn_Modelling
where CustomerId IN(select CustomerId from Churn_Modelling where Age=39)

select * from Churn_Modelling
select top 2 percent * from Churn_Modelling