

-----Cleaning Data in SQL queries

select * 
from sqlproject.dbo.nashvillehousing1

---Standardize Data Format



select SaleDateconvert, CONVERT(Date,SaleDate)
from sqlproject.dbo.nashvillehousing1

ALTER Table nashvillehousing1
Add Saledateconvert Date;

update nashvillehousing1
SET SaleDateconvert = CONVERT(Date,SaleDate)

-----Populate property address data


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.propertyAddress)
from sqlproject.dbo.nashvillehousing1 a
JOIN sqlproject.dbo.nashvillehousing1 b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from sqlproject.dbo.nashvillehousing1 a
JOIN sqlproject.dbo.nashvillehousing1 b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-----Breaking out Address into Indivisual Columns(Address,City ,State)


Select PropertyAddress
From sqlproject.dbo.nashvillehousing1 
---where property is Null
order by ParcelID

Select 
SUBSTRING(PropertyAddress ,1, CHARINDEX(',' ,PropertyAddress)-1 ) as Address,
SUBSTRING(PropertyAddress , CHARINDEX(',' ,PropertyAddress) +1 ,LEN(PropertyAddress) ) as Address
from sqlproject.dbo.nashvillehousing1


ALTER Table nashvillehousing1
Add PropertybreakAddress Nvarchar(255);

update nashvillehousing1
SET PropertybreakAddress = SUBSTRING(PropertyAddress ,1, CHARINDEX(',' ,PropertyAddress)-1 )

ALTER Table nashvillehousing1
Add PropertybreakCity Nvarchar(255);

update nashvillehousing1
SET PropertybreakCity= SUBSTRING(PropertyAddress , CHARINDEX(',' ,PropertyAddress) +1 ,LEN(PropertyAddress) )



select * 
from sqlproject.dbo.nashvillehousing1


select OwnerAddress
from sqlproject.dbo.nashvillehousing1


select 
PARSENAME (replace(OwnerAddress,',','.'),3),
PARSENAME (replace(OwnerAddress,',','.'),2),
PARSENAME (replace(OwnerAddress,',','.'),1)
from sqlproject.dbo.nashvillehousing1



ALTER Table nashvillehousing1
Add OwnerbreakAddress Nvarchar(255);

update nashvillehousing1
SET OwnerbreakAddress = PARSENAME (replace(OwnerAddress,',','.'),3)

ALTER Table nashvillehousing1
Add OwnerbreakCity Nvarchar(255);

update nashvillehousing1
SET OwnerbreakCity=PARSENAME (replace(OwnerAddress,',','.'),2)


ALTER Table nashvillehousing1
Add OwnerbreakState Nvarchar(255);

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From sqlproject.dbo.nashvillehousing1
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,CASE When SoldAsVacant= 'Y' THEN 'YES'
   WHEN SoldAsVacant='N' THEN 'NO'
   ELSE SoldAsVacant 
   END
from sqlproject.dbo.nashvillehousing1


Update nashvillehousing1
SET SoldAsVacant=CASE When SoldAsVacant= 'Y' THEN 'YES'
   WHEN SoldAsVacant='N' THEN 'NO'
   ELSE SoldAsVacant 
   END

   ---Remove Duplicates

 
WITH RowNumCTE AS(
Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  ORDER BY 
    UniqueID
    ) row_num
from sqlproject.dbo.nashvillehousing1
---order by ParcelID
)
DELETE
From RowNumCTE
Where row_num>1
---order by PropertyAddress


WITH RowNumCTE AS(
Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  ORDER BY 
    UniqueID
    ) row_num
from sqlproject.dbo.nashvillehousing1
---order by ParcelID
)
Select *  
From RowNumCTE
Where row_num>1
---order by PropertyAddress

----Delete Unused Columns

Select *
from sqlproject.dbo.nashvillehousing1

ALTER TABLE sqlproject.dbo.nashvillehousing1
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE sqlproject.dbo.nashvillehousing1
DROP COLUMN SaleDate
