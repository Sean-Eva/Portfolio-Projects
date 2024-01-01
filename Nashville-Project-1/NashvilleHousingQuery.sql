/*

Cleaning Data in SQL

*/

SELECT
*
FROM
PortfolioProjects.dbo.NashvilleHousing


------------------------------------------------------------
-- Standardize Date Format

Select
SaleDateConverted, CONVERT(Date, SaleDate)
FROM
PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


------------------------------------------------------------
-- Populate Property Address Data

Select
*
FROM
PortfolioProjects.dbo.NashvilleHousing
--WHERE
--PropertyAddress is null
ORDER BY
ParcelID

-- Looked for duplicated parcelIDs that we can then use as a reference to populate the value of the PropertyAddress Value

SELECT 
a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
PortfolioProjects.dbo.NashvilleHousing a JOIN PortfolioProjects.dbo.NashvilleHousing b ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE
a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
PortfolioProjects.dbo.NashvilleHousing a JOIN PortfolioProjects.dbo.NashvilleHousing b ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE
a.PropertyAddress is null


------------------------------------------------------------
-- Breaking Address into Individual Columns (Address, City, State)

-- We notice that there is always a ',' between the street address and the city name
SELECT
PropertyAddress
FROM
PortfolioProjects.dbo.NashvilleHousing

-- Use comma as delimiter to separate street and city from Property Address
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) AS City
FROM
PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))

-- Alternatively use OwnerAddress with delimiter '.' in PARSENAME to split Address values
SELECT
OwnerAddress
FROM
PortfolioProjects.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM
PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


------------------------------------------------------------
-- Change 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" field

SELECT
DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM
PortfolioProjects.dbo.NashvilleHousing
GROUP BY
SoldAsVacant
ORDER BY
2

-- Test fix using cases
SELECT
SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM
PortfolioProjects.dbo.NashvilleHousing

UPDATE
NashvilleHousing
SET
SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END


------------------------------------------------------------
-- Remove Duplicates
-- **while not usually a good practice to remove data, the methods will be demonstrated here

-- Deletes all the rows that show up as having the same values.
WITH RowNumCTE AS (
SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
				UniqueID) row_num
FROM
PortfolioProjects.dbo.NashvilleHousing
)
DELETE
FROM
RowNumCTE
WHERE
row_num > 1

-- Check Work
WITH RowNumCTE AS (
SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
				UniqueID) row_num
FROM
PortfolioProjects.dbo.NashvilleHousing
)
SELECT
*
FROM
RowNumCTE
WHERE
row_num > 1
ORDER BY PropertyAddress


--------------------------------------------------
-- Delete Unused Columns
-- **while not usually a good practice to remove data, the methods will be demonstrated here

SELECT
*
FROM
PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress