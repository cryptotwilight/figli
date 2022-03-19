// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;


interface IFigli { 

    function getNFTs() view external returns (uint256 [] memory _nftIds, string [] memory _titles, string [] memory _imageHashes, bool [] memory owned, bool [] memory shared, uint256[] memory _shareFees);

    function findNFT(uint256 _nftId) view external returns (uint256 _Id, string memory _title, string memory _imageHash, bool owned, bool shared, uint256 _shareFees);

    function getTotalEarnings() view external returns(uint256 _earnings);

    function getTotalWithdrawnEarnings() view external returns(uint256 _earnings);

    function getRemintFee() view external returns (uint256 _remintFee);

    function getMintFee() view external returns (uint256 _mintFee);

    function getUnlockReShareFee() view external returns (uint256 _unlockShareFee);

    function getFees() view external returns(uint256 _mintFee, uint256 unlockShareFee, uint256 _remintFee);


    function mint(string memory _imageHash, string memory _title, uint256 _fee) payable external returns (uint256 _nftId);

    function share(address _user, uint256 _nftId) external returns (bool _shared);

    function unlockReShare(uint256 _nftId, uint256 _fee) payable external returns (bool _shareUnlocked); 

    function reshare(address _user, uint256 _nftId) external returns (bool _shared);

    function remint(uint256 _nftId, uint256 _fee) payable external returns( uint256 _remintNFTId);

    function burn(uint256 _nftId) external returns (bool _burnt);

    function withdrawEarnings() external returns (uint256 _earnings);

}