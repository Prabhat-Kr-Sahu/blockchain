// SPDX-License-Identifier: MIT
pragma solidity >=0.7.10;

contract ResearchPaper {
    struct Paper {
        string title;
        string author;
        string abs;
        string keywords;
        uint256 timestamp;  // To record when the paper was submitted
        bool verified;   // To track if the paper has been verified
    }

    mapping(bytes32 => Paper) public papers;
    uint256 public paperCount;

    // Check if the paper already exists using a generated ID
    function paperExists(bytes32 paperId) public view returns (bool) {
        return bytes(papers[paperId].title).length > 0;
    }

    // Submit a paper if it doesn't exist, and return the unique ID
    function submitPaper(
        string memory _title, 
        string memory _author, 
        string memory _abs, 
        string memory _keywords
    ) public returns (bytes32) {
        // Generate a unique ID based on title, author, and current timestamp
        bytes32 paperId = keccak256(abi.encodePacked(_title, _author, block.timestamp));

        // Check if the paper with this ID already exists
        require(!paperExists(paperId), "Paper already exists on the blockchain.");

        // Store the paper
        papers[paperId] = Paper(_title, _author, _abs, _keywords, block.timestamp, false);
        paperCount++;

        // Return the unique ID to the caller
        return paperId;
    }

    // Retrieve a paper by its unique ID
    function getPaper(bytes32 _paperId)
        public
        view
        returns (
            string memory, 
            string memory, 
            string memory, 
            string memory, 
            uint256, 
            bool
        ) 
    {
        Paper memory p = papers[_paperId];
        require(bytes(p.title).length > 0, "Paper not found.");
        return (p.title, p.author, p.abs, p.keywords, p.timestamp, p.verified);
    }
}
