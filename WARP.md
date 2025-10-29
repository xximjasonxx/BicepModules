# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This is a Bicep Infrastructure-as-Code (IaC) modules library for Azure resources. The repository contains reusable Bicep modules organized by Azure service categories.

## Commands

### Bicep Validation and Linting
```bash
# Validate a Bicep file
az bicep build --file <file.bicep>

# Lint all Bicep files
find . -name "*.bicep" -exec az bicep build --file {} \;
```

### Deployment
```bash
# Deploy to a resource group
az deployment group create \
  --resource-group <rg-name> \
  --template-file <file.bicep> \
  --parameters <param1=value1>

# Deploy subscription-level resources
az deployment sub create \
  --location <location> \
  --template-file <file.bicep>

# Test deployment (what-if)
az deployment group what-if \
  --resource-group <rg-name> \
  --template-file <file.bicep>
```

### Bootstrap Example
```bash
# Deploy the bootstrap infrastructure
az deployment group create \
  --resource-group <rg-name> \
  --template-file bootstrap.bicep \
  --parameters adminPassword='<secure-password>'
```

## Architecture

### Module Structure

The repository follows a **two-tier module pattern**:

1. **Public modules** - User-facing modules with simplified parameters (e.g., `functionApp.bicep`, `account.bicep`)
2. **Private modules** - Internal implementation modules prefixed with `.` (e.g., `.functionApp.bicep`, `.sql-roleassignment.bicep`)

### Module Organization

Modules are organized by Azure service category:

- **cognitive/** - Azure Cognitive Services
- **compute/** - Virtual machines and compute resources
- **database/** - Database services (primarily CosmosDB with SQL API support)
- **general/** - Cross-cutting resources (resource groups)
- **networking/** - Virtual networks, network interfaces, private endpoints
- **roles/** - RBAC role assignments for Azure services
- **storage/** - Storage accounts, Key Vaults, secrets
- **web/** - App Services, Function Apps, and app settings

### Key Patterns

**Module Composition**
- Public modules call private modules using the `module` keyword
- Private modules contain actual resource definitions
- This separation allows for cleaner parameter interfaces and better encapsulation

**Parameter Handling**
- Use `@secure()` decorator for sensitive parameters (passwords, keys)
- Use `@allowed()` for constrained parameter values
- Default values provided where sensible (e.g., `location = resourceGroup().location`)

**Resource References**
- Use `existing` keyword to reference already-deployed resources
- Use `parent` property for nested resources
- Use `scope` parameter for cross-resource-group deployments

**Dynamic Resource Creation**
- Array-based parameters with `for` loops enable flexible multi-resource deployments
- Example: CosmosDB account can create multiple databases, each with multiple containers
- Role assignments dynamically created based on configuration arrays

**Output Patterns**
- Always output `resourceId` and `resourceName` for resource modules
- Output `principalId` when managed identity is enabled
- Use `reduce()` function for complex output transformations (see `virtualNetwork.bicep`)

### CosmosDB Module Pattern

The CosmosDB modules demonstrate advanced composition:

1. `account.bicep` - Creates CosmosDB account and orchestrates child resources
2. `sql/database.bicep` - Creates SQL database and collections
3. `sql/collection.bicep` - Creates individual containers
4. `.sql-roleassignment.bicep` - Assigns built-in Cosmos DB RBAC roles

Role assignments can be defined at three levels: account, database, or collection.

### Identity Configuration

Function Apps and other compute resources support three identity types:
- `none` - No managed identity
- `system` - System-assigned managed identity
- `managed` - User-assigned managed identity (requires `managedIdentityId`)

## File Naming Conventions

- Public modules: `resourceType.bicep` (e.g., `virtualMachine.bicep`)
- Private modules: `.resourceType.bicep` (e.g., `.functionApp.bicep`)
- Wrapper/orchestration modules: `main.bicep` or descriptive names (e.g., `bootstrap.bicep`)
