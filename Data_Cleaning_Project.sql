--Cleaning Data in SQL Queries

select * from [Datacleaning_project]..housing_details

----------------------------------------------------------------------------------
-- Standardize Date Format

ALTER table [datacleaning_project]..housing_details
add Sale_date date

Update [Datacleaning_project]..housing_details 
set sale_date=convert(date,saledate)

select saledate,sale_date from [Datacleaning_project]..housing_details

------------------------------

--Deleting column saledate

ALTER table [datacleaning_project]..housing_details 
drop column saledate

----------------------------------------------------------------------------------

-- Populate Property Address data 


select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress from [Datacleaning_project]..housing_details a
join housing_details b 
on a.ParcelID=b.ParcelID and
a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set  a.PropertyAddress= b.PropertyAddress
from [Datacleaning_project]..housing_details a join [Datacleaning_project]..housing_details b on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ] 
where a.PropertyAddress is null


----------------------------------------------------------------------------------

-- Breaking out PropertyAddress into Individual Columns (Address, City)

select 
 PARSENAME (REPLACE(PropertyAddress,',','.'),1),
 PARSENAME (REPLACE(PropertyAddress,',','.'),2)
 from [Datacleaning_project]..housing_details

Alter table housing_details 
add house_address varchar(255),city varchar(255)

update housing_details 
set house_address=PARSENAME(replace(propertyaddress,',','.'),2) ,city=PARSENAME(replace(propertyaddress,',','.'),1)    

select house_address,city from housing_details

----------------------------------------------------------------------------------

-- Spiliting owner address into ownercity. ownerstate, owner street

select 
 PARSENAME (REPLACE(OwnerAddress,',','.'),1),
 PARSENAME (REPLACE(OwnerAddress,',','.'),2),
 PARSENAME (REPLACE(OwnerAddress,',','.'),3)
 from [Datacleaning_project]..housing_details

 alter table housing_details
 add owner_address varchar(255),owner_city varchar(255),owner_state varchar(255)

 update housing_details
 set owner_address=PARSENAME (REPLACE(OwnerAddress,',','.'),3) ,
 owner_city=PARSENAME (REPLACE(OwnerAddress,',','.'),2) ,
 owner_city=PARSENAME (REPLACE(OwnerAddress,',','.'),1)

 Select street_owneraddress,city_owneraddress,state_owneraddress housing_details

 ----------------------------------------------------------------------------------

 -- Changing Y and N to Yes and No in "sold as vacant" column

 Update housing_details
 set soldasvacant=case
                      when soldasvacant='y' then 'Yes'
					  when SoldAsVacant='n' then 'No'
					  else SoldAsVacant
					  End
Select distinct(soldasvacant) from housing_details