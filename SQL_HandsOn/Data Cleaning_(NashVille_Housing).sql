Select * 
 from Portfolio_Project.dbo.NashVille_Housing

 --Standardize Date Format

 Select SaleDate, Convert(Date,SaleDate)
 from Portfolio_Project.dbo.NashVille_Housing

 Alter Table NashVille_Housing
 Add SaleDateConverted Date;

 Update NashVille_Housing
 Set SaleDateConverted = Convert(Date,SaleDate)


 --Populate Propety Address Data

 Select PropertyAddress
 from Portfolio_Project.dbo.NashVille_Housing
 where PropertyAddress is null

  Select *
 from Portfolio_Project.dbo.NashVille_Housing
 where PropertyAddress is null


  Select *
 from Portfolio_Project.dbo.NashVille_Housing
order by ParcelID

--Every ParcelID is associated with only one PropertyAddress
--Using self Join

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
  ISNULL(a.PropertyAddress,b.PropertyAddress)
 from Portfolio_Project.dbo.NashVille_Housing a
 Join Portfolio_Project.dbo.NashVille_Housing b
      on a.ParcelID=b.ParcelID
	  and a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
 from Portfolio_Project.dbo.NashVille_Housing a
 Join Portfolio_Project.dbo.NashVille_Housing b
      on a.ParcelID=b.ParcelID
	  and a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null 




--Breaking out PropertyAddress and OwnerAddress into (Address,City,State)

 Select 
 SubString(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
 SubString(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as City
 from Portfolio_Project.dbo.NashVille_Housing


 --SubString(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as City
 --CHARINDEX(',',PropertyAddress)+1      To start with  after ',' 
 --To the end at Len(PropertyAddress) end of the PropertyAddress

 Alter Table NashVille_Housing
 Add PropertySplitAddress Nvarchar(255);

 Update NashVille_Housing
 Set PropertySplitAddress =  SubString(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 


 Alter Table NashVille_Housing
 Add PropertySplitCity Nvarchar(255);

 Update NashVille_Housing
 Set PropertySplitCity =  SubString(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))



Select
Parsename(replace (OwnerAddress,',','.'), 3),
Parsename(replace (OwnerAddress,',','.'), 2),
Parsename(replace (OwnerAddress,',','.'), 1)
from Portfolio_Project.dbo.NashVille_Housing 


 Alter Table NashVille_Housing
 Add OwnerSplitAddress Nvarchar(255);

 Update NashVille_Housing
 Set OwnerSplitAddress =  Parsename(replace (OwnerAddress,',','.'), 3) 


 Alter Table NashVille_Housing
 Add OwnerSplitCity Nvarchar(255);

 Update NashVille_Housing
 Set OwnerSplitCity =  Parsename(replace (OwnerAddress,',','.'), 2)


  Alter Table NashVille_Housing
 Add OwnerSplitState Nvarchar(255);

 Update NashVille_Housing
 Set OwnerSplitState =  Parsename(replace (OwnerAddress,',','.'), 1)

   Alter Table NashVille_Housing
 drop column OwnerSplitAddress,OwnerSplitCity,OwnerySplitState
 

 --Change Y and N  to Yes and No in "SoldAsVacant" field

 Select Distinct(SoldAsVacant), Count(SoldAsVacant)
 from Portfolio_Project.dbo.NashVille_Housing 
 Group by SoldAsVacant
 Order by 2

 --Using Case Statement

 Select SoldAsVacant,
 Case When SoldAsVacant='Y' then 'Yes'
      When SoldAsVacant='N' then 'No'
	  Else SoldAsVacant
      End
 from Portfolio_Project.dbo.NashVille_Housing 

  Update NashVille_Housing
  Set SoldAsVacant= Case When SoldAsVacant='Y' then 'Yes'
      When SoldAsVacant='N' then 'No'
	  Else SoldAsVacant
      End


--Removing Duplicates
-- Using windows functions to identify duplicates row

Select *,
ROW_NUMBER() OVER (Partition By ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference Order by UniqueID) row_num
 from Portfolio_Project.dbo.NashVille_Housing 
 order by ParcelID

 With RowNumCTE as(
 Select *,
ROW_NUMBER() OVER (Partition By ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference Order by UniqueID) row_num
 from Portfolio_Project.dbo.NashVille_Housing )
 Select *
 from RowNumCTE
 Where row_num>1
 order by PropertyAddress


 --Now Deletingthe Duplicate Values
  With RowNumCTE as(
 Select *,
ROW_NUMBER() OVER (Partition By ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference Order by UniqueID) row_num
 from Portfolio_Project.dbo.NashVille_Housing )
 Delete
 from RowNumCTE
 Where row_num>1
 --order by PropertyAddress


-- Deleting the Unused Columns

   Alter Table NashVille_Housing
 drop column PropertyAddress,OwnerAddress,SaleDate

    Alter Table NashVille_Housing
 drop column SaleDate


 Select * 
 from Portfolio_Project.dbo.NashVille_Housing