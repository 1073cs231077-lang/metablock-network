// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Metablock Network - Project Contract
 * @dev A simple project registry and funding contract
 */
contract Project {
    struct ProjectInfo {
        string name;
        string description;
        address creator;
        uint256 funds;
    }

    mapping(uint256 => ProjectInfo) public projects;
    uint256 public projectCount;

    event ProjectCreated(uint256 indexed projectId, string name, address creator);
    event Funded(uint256 indexed projectId, uint256 amount, address funder);

    /**
     * @dev Create a new project.
     * @param _name Title of the project
     * @param _description Short description
     */
    function createProject(string calldata _name, string calldata _description)
        external
    {
        projectCount++;
        projects[projectCount] = ProjectInfo({
            name: _name,
            description: _description,
            creator: msg.sender,
            funds: 0
        });

        emit ProjectCreated(projectCount, _name, msg.sender);
    }

    /**
     * @dev Fund a project with ETH.
     * @param _projectId The ID of the project to fund
     */
    function fundProject(uint256 _projectId) external payable {
        require(_projectId > 0 && _projectId <= projectCount, "Invalid project");
        require(msg.value > 0, "Must send ETH");

        projects[_projectId].funds += msg.value;

        emit Funded(_projectId, msg.value, msg.sender);
    }

    /**
     * @dev Get project details.
     * @param _projectId The ID of the project
     */
    function getProject(uint256 _projectId)
        external
        view
        returns (
            string memory,
            string memory,
            address,
            uint256
        )
    {
        require(_projectId > 0 && _projectId <= projectCount, "Invalid project");
        ProjectInfo memory p = projects[_projectId];
        return (p.name, p.description, p.creator, p.funds);
    }
}
