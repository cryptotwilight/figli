// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;


interface IFigli { 

    function getNFTs() view external returns (uint256 [] memory _nftIds, string [] memory _titles, string [] memory _imageHashes, bool [] memory _owned, bool [] memory _shared, string [] memory _reshareUnlocked,  uint256[] memory _shareFees);

    function findNFT(uint256 _nftId) view external returns (uint256 _Id, string memory _title, string memory _imageHash, bool _owned, bool _shared, string memory _reshareUnlocked, uint256 _shareFees);

    function getShareCounts(uint256 _nftId) view external returns(uint256 _shares, uint256 _reshares, uint256 _remints);

    function getTotalEarnings() view external returns(uint256 _earnings);

    function getTotalWithdrawnEarnings() view external returns(uint256 _earnings);

    function getRemintFee() view external returns (uint256 _remintFee);

    function getMintFee() view external returns (uint256 _mintFee);

    function getUnlockReShareFee() view external returns (uint256 _unlockShareFee);

    function getFees() view external returns(uint256 _mintFee, uint256 unlockShareFee, uint256 _remintFee, uint256 _unhideFee);


    function mint(string memory _imageHash, string memory _title, uint256 _fee) payable external returns (uint256 _nftId); //@done

    function share(address _user, uint256 _nftId) external returns (bool _shared);

    function unlockReShare(uint256 _nftId, uint256 _fee) payable external returns (bool _shareUnlocked); 

    function reshare(address _user, uint256 _nftId) external returns (bool _shared);

    function remint(uint256 _nftId, uint256 _fee) payable external returns( uint256 _remintNFTId);

    function burn(uint256 _nftId) external returns (bool _burnt);

    function trash(uint256 _nftId) external returns (bool _trashed);

    function hide(uint256 _nftId) external returns( bool _hidden );

    function unhide(uint256 _nftId, uint256 _fee) payable external returns (bool _unhidden);

    function withdrawEarnings() external returns (uint256 _earnings);

}