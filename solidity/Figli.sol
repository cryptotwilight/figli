// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/52eeebecda140ebaf4ec8752ed119d8288287fac/contracts/token/ERC721/ERC721.sol";
import "./IFigli.sol";
import "./LFigli.sol";

contract Figli is IFigli, ERC721 {

    using LFigli for uint256;

    address administrator; 

    uint256 ownerShareFee       = 1; 
    uint256 remintOwnerShareFee = 1; 

    uint256 remintOwnerRemintFee = 5; 
    uint256 originalOwnerRemintFee = 1; 

    uint256 mintFee             = 10; 
    uint256 unlockReShareFee    = 10; 
    uint256 remintFee           = 15;

    uint256 unhideFee           = 1000; 

    uint256 mintIndex           = 0; 

    uint256 figliEarnings; 
    uint256 figliWithdrawals; 

    mapping(address=>uint256) earningsByAddress; 
    mapping(address=>uint256) withdrawnEarningsByAddress; 

    mapping(uint256=>string)  uriByTokenId;
    mapping(uint256=>uint256[]) reMintByMint; 

    mapping(address=>mapping(uint256=>address[])) sharesByNFTByAddress;

    mapping(address=>mapping(uint256=>bool)) nftReShareUnlockedByAddress; 

    mapping(uint256=>NFT) nftById; 

    mapping(address=>uint256[]) nftsByUser; 

    mapping(address=>mapping(uint256=>bool)) nftSeenByNFTByAddress; 

    mapping(uint256=>bool) isRemint; 
    mapping(uint256=>uint256) originalByRemint;

    struct NFT { 
        uint256 id; 
        string title; 
        string imageHash;
        bool shared; 
        uint256 shareFees;
        bool hidden;
        uint256 shares; 
        uint256 reshares; 
        uint256 remints;       
    }

    constructor(address _administrator, string memory _name, string memory _symbol ) ERC721(_name, _symbol) {
        administrator = _administrator; 
    }

    function getNFTs() view external returns (uint256 [] memory _nftIds, string [] memory _titles, string[] memory _imageHash, bool [] memory _owned, bool [] memory _shared, string [] memory _reshareUnlocked,  uint256[] memory _shareFees){
        uint256[] memory nfts_ = nftsByUser[msg.sender];
        _nftIds     = new uint256[](nfts_.length);
        _titles     = new string[](nfts_.length);
        _imageHash     = new string[](nfts_.length);
        _owned      = new bool[](nfts_.length);
        _reshareUnlocked = new string[](nfts_.length);
        _shared     = new bool[](nfts_.length);
        _shareFees  = new uint256[](nfts_.length);
        for(uint256 x = 0; x < nfts_.length; x++) {
            NFT memory nft_ = nftById[nfts_[x]];
            _nftIds[x] = nft_.id; 
            _titles[x] = nft_.title; 
            _imageHash[x] = nft_.imageHash; 
            _owned[x] = (ownerOf(nft_.id) == msg.sender);
            if(!_owned[x]){
                if(nftReShareUnlockedByAddress[msg.sender][_nftIds[x]]){
                    _reshareUnlocked[x] = "UNLOCKED";
                }
                else {
                    _reshareUnlocked[x] = "LOCKED";
                }
            }
            else {
                _reshareUnlocked[x] = "N/A";
            }
            _shared[x] = nft_.shared; 
            _shareFees[x] = nft_.shareFees;
        }
        return (_nftIds, _titles, _imageHash, _owned, _shared, _reshareUnlocked, _shareFees);
    }

    function findNFT(uint256 _nftId) view external returns (uint256 _Id, string memory _title, string memory _ipfsHash, bool _owned, bool _shared, string memory _reshareUnlocked, uint256 _shareFees){
        NFT memory nft_ = nftById[_nftId];
        _owned = (ownerOf(_nftId) == msg.sender);
        if(!_owned){
            if(nftReShareUnlockedByAddress[msg.sender][_nftId]){
                _reshareUnlocked = "UNLOCKED";
            }
            else {
                _reshareUnlocked = "LOCKED";
            }
        }
        else {
            _reshareUnlocked = "N/A";
        }
        return (_nftId, nft_.title, nft_.imageHash, _owned, nft_.shared, _reshareUnlocked, nft_.shareFees );
    }

    function getShareCounts(uint256 _nftId) view external returns(uint256 _shares, uint256 _reshares, uint256 _remints){
        NFT memory nft_ = nftById[_nftId];
        return (nft_.shares, nft_.reshares, nft_.remints);
    }


    function getTotalEarnings() view external returns(uint256 _earnings){
        return earningsByAddress[msg.sender];
    }

    function getTotalWithdrawnEarnings() view external returns(uint256 _earnings) {
        return withdrawnEarningsByAddress[msg.sender];
    }

    function getRemintFee() view external returns (uint256 _remintFee){
        return remintFee; 
    }

    function getMintFee() view external returns (uint256 _mintFee){
        return mintFee; 
    }

    function getUnlockReShareFee() view external returns (uint256 _unlockShareFee){
        return unlockReShareFee;
    }    

    function getFees() view external returns(uint256 _mintFee, uint256 _unlockShareFee, uint256 _remintFee, uint256 _unhideFee){
        return(mintFee, unlockReShareFee, remintFee, unhideFee);
    }

    function mint(string memory _imageHash, string memory _title, uint256 _fee) payable external returns (uint256 _nftId ){
        require(msg.value == _fee, " transmitted <-> declared value mis-match ");
        pay(_fee, mintFee);
        figliEarnings += mintFee;         
        return mintInternal(msg.sender, _imageHash, _title); 
    }

    function share(address _user, uint256 _nftId) external returns (bool _shared){
        require(ownerOf(_nftId) == msg.sender," only owners can share ");
        require(!nftSeenByNFTByAddress[_user][_nftId], " user has already seen nft ");
        require(nftById[_nftId].hidden == false, " cannot share hidden nft ");
        nftById[_nftId].shared = true; 
        nftsByUser[_user].push(_nftId);
        sharesByNFTByAddress[msg.sender][_nftId].push(_user);
         nftById[_nftId].shares++;
        return true; 
    }

    function unlockReShare(uint256 _nftId,  uint256 _fee) payable external returns (bool _shareUnlocked){
        require(msg.value == _fee, " transmitted <-> declared value mis-match ");
        require(_nftId.isContained(nftsByUser[msg.sender]), " must hold nft to unlock re-share");

        pay(_fee, unlockReShareFee);
        uint256 figliCut = _fee; 
        if(isRemint[_nftId]){
            uint256 originalNFT = originalByRemint[_nftId];
            address originalOwner = ownerOf(originalNFT);
            address remintOwner = ownerOf(_nftId);
            earningsByAddress[remintOwner]   += remintOwnerShareFee;
            figliCut -= remintOwnerRemintFee;
            earningsByAddress[originalOwner] += ownerShareFee;  
            figliCut -= originalOwnerRemintFee;
        }
        else {
            address owner = ownerOf(_nftId);
            earningsByAddress[owner] += ownerShareFee;  
            figliCut -= originalOwnerRemintFee;
        }
        nftReShareUnlockedByAddress[msg.sender][_nftId] = true;
        return true; 
    } 

    function reshare(address _user, uint256 _nftId) external returns (bool _shared){
        require(nftReShareUnlockedByAddress[msg.sender][_nftId], " unlock reshare first ");
        require(_nftId.isContained(nftsByUser[msg.sender]), " must hold nft to reshare ");
        require(!nftSeenByNFTByAddress[_user][_nftId], " user has already seen this nft ");
        nftsByUser[_user].push(_nftId);
        sharesByNFTByAddress[msg.sender][_nftId].push(_user);
        nftById[_nftId].reshares++;
        return true;
    }

    function remint(uint256 _nftId, uint256 _fee) payable external returns( uint256 _remintId){
        require(msg.value == _fee, " transmitted <-> declared value mis-match ");
        require(_nftId.isContained(nftsByUser[msg.sender]), " must hold nft to remint ");
        pay(_fee, remintFee);
        NFT memory nft_ = nftById[_nftId];

        uint256 remintId_ = mintInternal(msg.sender, nft_.imageHash, nft_.title);        
        nftById[_nftId].shareFees += _fee; 
        
        uint256 figliCut = _fee; 
        if(isRemint[_nftId]){
            uint256 originalNFTId_ = originalByRemint[_nftId];
            originalByRemint[remintId_] = originalNFTId_;
            nftById[originalNFTId_].remints++; 
            nftById[_nftId].remints++;

            address originalOwner = ownerOf(originalNFTId_);
            address remintOwner = ownerOf(_nftId);

            earningsByAddress[remintOwner]   += remintOwnerRemintFee;
            figliCut -= remintOwnerRemintFee;
            earningsByAddress[originalOwner] += originalOwnerRemintFee;  
            figliCut -= originalOwnerRemintFee;
            
        }
        else {
            address owner = ownerOf(_nftId);
            originalByRemint[remintId_] = _nftId; 
            nftById[_nftId].remints++;

            earningsByAddress[owner] += originalOwnerRemintFee;
            figliCut -= originalOwnerRemintFee;
        }
        figliEarnings += figliCut; 
        isRemint[remintId_] = true;         
        return remintId_; 
    }

    function burn(uint256 _nftId) external returns (bool _burnt){
        require(ownerOf(_nftId) == msg.sender, " only owners can burn ");
        require(nftById[_nftId].hidden == false, " cannot burn hidden nft ");
        require(nftById[_nftId].shared == false, " shared nfts cannot be burnt ");

        delete nftById[_nftId];
        nftsByUser[msg.sender] = _nftId.remove(nftsByUser[msg.sender]);
        _burn(_nftId);
        return true;
    }

    function trash(uint256 _nftId) external returns (bool _trashed) {
        require(ownerOf(_nftId) != msg.sender, " owners cannot trash ");
        nftsByUser[msg.sender] = _nftId.remove(nftsByUser[msg.sender]);
        return true;         
    }

    function hide(uint256 _nftId) external returns( bool _hidden ){
        require(ownerOf(_nftId) == msg.sender, " only owners can hide NFTs ");
        nftById[_nftId].hidden = true; 
        return true; 
    }

    function unhide(uint256 _nftId, uint256 _fee) payable external returns (bool _unhidden) {
        require(ownerOf(_nftId) == msg.sender, " only owners can unhide NFTs ");
        require(msg.value == _fee, " transmitted <-> declared value mis-match ");        
        pay(_fee, unhideFee);
        nftById[_nftId].hidden = false;
        return true; 
    }

    function withdrawEarnings() external returns (uint256 _earnings){
        uint256 earnings_ = earningsByAddress[msg.sender];
        if(earnings_ > 0) {
            earningsByAddress[msg.sender] -= earnings_;
            withdrawnEarningsByAddress[msg.sender] += earnings_; 
            address payable user_ = payable(msg.sender);
            user_.transfer(earnings_);
            return earnings_; 
        }
        return 0; 
    }

    function withdrawFigliEarnings() external returns(uint256 _earnings) {
        address payable admin_ = payable(administrator);
        uint256 withdrawal = figliEarnings;
        figliEarnings -= withdrawal; 
        figliWithdrawals += withdrawal; 
        admin_.transfer(withdrawal);
        return withdrawal; 
    }

    function getFigliEarningsData() view external returns(uint256 _earnings, uint256 _withdrawals){
        adminOnly();
        return (figliEarnings, figliWithdrawals);
    }

    function setRemintFee( uint256 _fee )  external returns (bool _set){
        adminOnly(); 
        remintFee = _fee; 
        return true; 
    }

    function setMintFee( uint256 _fee )  external returns (bool _set){
        adminOnly(); 
        mintFee = _fee; 
        return true; 
    }

    function setUnlockReShareFee( uint256 _fee )  external returns (bool _set){
        adminOnly(); 
        unlockReShareFee = _fee; 
        return true; 

    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return uriByTokenId[tokenId];        
    }

    //======================================== INTERNAL ================

    function adminOnly() view internal {
        require(msg.sender == administrator, "admin only");
    }

    function pay(uint256 _paidAmount, uint256 _referenceFee) pure internal { 
        require(_paidAmount >= _referenceFee, "insufficient amount sent");
    }

    function mintInternal(address _owner, string memory _imageHash, string memory _title) internal returns (uint256 _nftId) {        
        _nftId = mintIndex++;
        _safeMint(_owner, _nftId, bytes(_imageHash) );
        nftsByUser[_owner].push(_nftId);
        NFT memory nft_ = NFT({
                        id : _nftId,
                        title : _title, 
                        imageHash : _imageHash,
                        shared : false, 
                        shareFees : 0,
                        hidden : false,
                        shares : 0,
                        reshares : 0, 
                        remints : 0 
                        });
        nftById[_nftId] = nft_;                         
        nftSeenByNFTByAddress[_owner][_nftId] = true; 
        return _nftId;
    }

}