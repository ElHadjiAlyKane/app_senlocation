# API Documentation

## Base URL
```
https://api.senlocation.sn
```

## Authentication

### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securepassword",
  "role": "landlord" // or "tenant" or "lawyer"
}

Response:
{
  "success": true,
  "message": "Inscription réussie"
}
```

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "securepassword"
}

Response:
{
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "landlord"
  }
}
```

## Properties

### List Properties
```http
GET /api/properties
Authorization: Bearer {token}

Response:
{
  "properties": [
    {
      "id": "property_id",
      "title": "Appartement 3 pièces",
      "description": "Bel appartement...",
      "address": "Dakar, Sénégal",
      "type": "apartment",
      "bedrooms": 3,
      "bathrooms": 2,
      "area": 85.5,
      "price": 250000,
      "available": true
    }
  ]
}
```

### Get Property Details
```http
GET /api/properties/:id
Authorization: Bearer {token}

Response:
{
  "property": {
    "id": "property_id",
    "title": "Appartement 3 pièces",
    "description": "Bel appartement...",
    "address": "Dakar, Sénégal",
    "type": "apartment",
    "bedrooms": 3,
    "bathrooms": 2,
    "area": 85.5,
    "price": 250000,
    "available": true,
    "landlord": {
      "id": "landlord_id",
      "name": "John Doe"
    }
  }
}
```

### Create Property (Landlord only)
```http
POST /api/properties
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Villa moderne",
  "description": "Belle villa...",
  "address": "Almadies, Dakar",
  "type": "villa",
  "bedrooms": 4,
  "bathrooms": 3,
  "area": 200,
  "price": 500000,
  "available": true
}

Response:
{
  "success": true,
  "property": {
    "id": "new_property_id",
    ...
  }
}
```

### Update Property (Landlord only)
```http
PUT /api/properties/:id
Authorization: Bearer {token}
Content-Type: application/json

{
  "price": 275000,
  "available": false
}

Response:
{
  "success": true,
  "message": "Propriété mise à jour"
}
```

### Delete Property (Landlord only)
```http
DELETE /api/properties/:id
Authorization: Bearer {token}

Response:
{
  "success": true,
  "message": "Propriété supprimée"
}
```

## User Profile

### Get Profile
```http
GET /api/user/profile
Authorization: Bearer {token}

Response:
{
  "user": {
    "id": "user_id",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+221 XX XXX XX XX",
    "role": "landlord"
  }
}
```

### Update Profile
```http
PUT /api/user/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "John Updated",
  "phone": "+221 XX XXX XX XX",
  "password": "newpassword" // optional
}

Response:
{
  "success": true,
  "message": "Profil mis à jour"
}
```

## Rental Agreements

### List Rental Agreements
```http
GET /api/rental-agreements
Authorization: Bearer {token}

Response:
{
  "agreements": [
    {
      "id": "agreement_id",
      "property": {
        "id": "property_id",
        "title": "Appartement 3 pièces"
      },
      "landlord": {
        "id": "landlord_id",
        "name": "John Doe"
      },
      "tenant": {
        "id": "tenant_id",
        "name": "Jane Smith"
      },
      "startDate": "2024-01-01",
      "duration": 12,
      "status": "active"
    }
  ]
}
```

### Create Rental Agreement (Landlord/Lawyer only)
```http
POST /api/rental-agreements
Authorization: Bearer {token}
Content-Type: application/json

{
  "propertyId": "property_id",
  "tenantId": "tenant_id",
  "startDate": "2024-01-01",
  "duration": 12
}

Response:
{
  "success": true,
  "agreement": {
    "id": "new_agreement_id",
    ...
  }
}
```

## Error Responses

All endpoints may return these error responses:

### 400 Bad Request
```json
{
  "error": "Invalid request",
  "message": "Detailed error message"
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Token invalide ou expiré"
}
```

### 403 Forbidden
```json
{
  "error": "Forbidden",
  "message": "Vous n'avez pas la permission d'effectuer cette action"
}
```

### 404 Not Found
```json
{
  "error": "Not found",
  "message": "Ressource introuvable"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error",
  "message": "Une erreur s'est produite"
}
```

## Rate Limiting

The API implements rate limiting:
- 100 requests per minute per user
- 1000 requests per hour per user

Exceeded limits will return:
```json
{
  "error": "Rate limit exceeded",
  "message": "Trop de requêtes, veuillez réessayer plus tard"
}
```
