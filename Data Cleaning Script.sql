-- Data Cleaning( These Query is specifically for cleaning the Nashville Housing Data

select * 
from PortfolioProject..NashvilleHousing


-- standardize Date Format 

Select SaleDate, convert(Date, saledate)
from PortfolioProject..NashvilleHousing


update PortfolioProject..NashvilleHousing
set SaleDate = convert (Date, Saledate)

Alter Table PortfolioProject..NashvilleHousing
add SaleDate_Converted Date;

update PortfolioProject..NashvilleHousing
set SaleDate_Converted = convert (Date, Saledate);

Select SaleDate_Converted , convert(Date, saledate)
from PortfolioProject..NashvilleHousing;


-- Populate Property address data

select * 
from PortfolioProject..NashvilleHousing
order by ParcelID;  -- checking address with null value but with same parcelid


select a.ParcelID , b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null -- joining the same table to help me check and eliminate the null values 

update a
set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null --replacing the null values on a by creating another column


--- Breaking address into individual columns (address,city,state)
select OwnerAddress
from PortfolioProject..NashvilleHousing


select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitAddress  = PARSENAME(Replace(OwnerAddress,',','.'),3);


Alter Table PortfolioProject..NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2);


Alter Table PortfolioProject..NashvilleHousing
add OwnerSplitState Nvarchar(255) ;

update PortfolioProject..NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1);


-- Changing Y and N to Yes and No in "soldAsVacant" field

select Distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by SoldAsVacant



Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
from PortfolioProject..NashvilleHousing;


update PortfolioProject..NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End;



-- Removing Duplicates

with RowNumCTE as (
select *, 
	ROW_NUMBER() over (
	Partition by Parcelid,
				 PropertyAddress,
				 SalePrice,
				 Saledate,
				 LegalReference
				 order by 
				 UniqueId
				 ) row_num
from PortfolioProject..NashvilleHousing
)
delete 
from RowNumCTE
where row_num > 1

