iFigliAbi = [{
        "inputs": [{
            "internalType": "uint256",
            "name": "_nftId",
            "type": "uint256"
        }],
        "name": "burn",
        "outputs": [{
            "internalType": "bool",
            "name": "_burnt",
            "type": "bool"
        }],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [{
            "internalType": "uint256",
            "name": "_nftId",
            "type": "uint256"
        }],
        "name": "findNFT",
        "outputs": [{
                "internalType": "uint256",
                "name": "_Id",
                "type": "uint256"
            },
            {
                "internalType": "string",
                "name": "_title",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "_imageHash",
                "type": "string"
            },
            {
                "internalType": "bool",
                "name": "owned",
                "type": "bool"
            },
            {
                "internalType": "bool",
                "name": "shared",
                "type": "bool"
            },
            {
                "internalType": "uint256",
                "name": "_shareFees",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getFees",
        "outputs": [{
                "internalType": "uint256",
                "name": "_mintFee",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "unlockShareFee",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "_remintFee",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getMintFee",
        "outputs": [{
            "internalType": "uint256",
            "name": "_mintFee",
            "type": "uint256"
        }],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getNFTs",
        "outputs": [{
                "internalType": "uint256[]",
                "name": "_nftIds",
                "type": "uint256[]"
            },
            {
                "internalType": "string[]",
                "name": "_titles",
                "type": "string[]"
            },
            {
                "internalType": "string[]",
                "name": "_imageHashes",
                "type": "string[]"
            },
            {
                "internalType": "bool[]",
                "name": "owned",
                "type": "bool[]"
            },
            {
                "internalType": "bool[]",
                "name": "shared",
                "type": "bool[]"
            },
            {
                "internalType": "uint256[]",
                "name": "_shareFees",
                "type": "uint256[]"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getRemintFee",
        "outputs": [{
            "internalType": "uint256",
            "name": "_remintFee",
            "type": "uint256"
        }],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getTotalEarnings",
        "outputs": [{
            "internalType": "uint256",
            "name": "_earnings",
            "type": "uint256"
        }],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getTotalWithdrawnEarnings",
        "outputs": [{
            "internalType": "uint256",
            "name": "_earnings",
            "type": "uint256"
        }],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getUnlockReShareFee",
        "outputs": [{
            "internalType": "uint256",
            "name": "_unlockShareFee",
            "type": "uint256"
        }],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [{
                "internalType": "string",
                "name": "_imageHash",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "_title",
                "type": "string"
            },
            {
                "internalType": "uint256",
                "name": "_fee",
                "type": "uint256"
            }
        ],
        "name": "mint",
        "outputs": [{
            "internalType": "uint256",
            "name": "_nftId",
            "type": "uint256"
        }],
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "inputs": [{
                "internalType": "uint256",
                "name": "_nftId",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "_fee",
                "type": "uint256"
            }
        ],
        "name": "remint",
        "outputs": [{
            "internalType": "uint256",
            "name": "_remintNFTId",
            "type": "uint256"
        }],
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "inputs": [{
                "internalType": "address",
                "name": "_user",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "_nftId",
                "type": "uint256"
            }
        ],
        "name": "reshare",
        "outputs": [{
            "internalType": "bool",
            "name": "_shared",
            "type": "bool"
        }],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [{
                "internalType": "address",
                "name": "_user",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "_nftId",
                "type": "uint256"
            }
        ],
        "name": "share",
        "outputs": [{
            "internalType": "bool",
            "name": "_shared",
            "type": "bool"
        }],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [{
                "internalType": "uint256",
                "name": "_nftId",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "_fee",
                "type": "uint256"
            }
        ],
        "name": "unlockReShare",
        "outputs": [{
            "internalType": "bool",
            "name": "_shareUnlocked",
            "type": "bool"
        }],
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "withdrawEarnings",
        "outputs": [{
            "internalType": "uint256",
            "name": "_earnings",
            "type": "uint256"
        }],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]