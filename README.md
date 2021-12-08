# Testing impersonation feature with OpenSearch

Before running the docker-compose, set owner:group of the ./config/opensearch/config folder to a user with ID `1000:1000`. That will allow to map opnsearch config files in the opensearch containers. 


## The below lines were added to opensearch.yml to enable impersonation.

    plugins.security.authcz.rest_impersonation_user:
      "impersonator":
        - "*"

## Follow the below steps to test impresonation feature. 

### 1. Create users `user1` and `impresonator`.
     
    curl -k --header "Content-Type: application/json"   --request PUT   --data '{"password":"user1","opendistro_security_roles":["alerting_read_access"],"backend_roles":["foo","baz"]}'   https://admin:admin@localhost:9200/_plugins/_security/api/internalusers/user1

    curl -k --header "Content-Type: application/json"   --request PUT   --data '{"password":"impersonator","opendistro_security_roles":["alerting_ack_alerts"],"backend_roles": ["foo", "bar"]}'   https://admin:admin@localhost:9200/_plugins/_security/api/internalusers/impersonator


### 2. Check authinfo of both users.

    curl -XGET -u impersonator:impersonator -k "https://127.0.0.1:9200/_plugins/_security/authinfo?pretty"

    curl -XGET -u user1:user1 -k "https://127.0.0.1:9200/_plugins/_security/authinfo?pretty"


### 3. Test impersonation feature.

    curl -XGET -u impersonator:impersonator -k -H "opendistro_security_impersonate_as: user1" "https://127.0.0.1:9200/_plugins/_security/authinfo?pretty"


### Expected output.

    curl -XGET -u user1:user1 -k "https://127.0.0.1:9200/_plugins/_security/authinfo?pretty"
    {
      "user" : "User [name=user1, backend_roles=[foo, baz], requestedTenant=null]",
      "user_name" : "user1",
      "user_requested_tenant" : null,
      "remote_address" : "192.168.160.1:36622",
      "backend_roles" : [
        "foo",
        "baz"
      ],
      "custom_attribute_names" : [ ],
      "roles" : [
        "own_index",
        "alerting_read_access"
      ],
      "tenants" : {
        "user1" : true
      },
      "principal" : null,
      "peer_certificates" : "0",
      "sso_logout_url" : null
    }

    curl -XGET -u impersonator:impersonator -k "https://127.0.0.1:9200/_plugins/_security/authinfo?pretty"
    {
      "user" : "User [name=impersonator, backend_roles=[bar, foo], requestedTenant=null]",
      "user_name" : "impersonator",
      "user_requested_tenant" : null,
      "remote_address" : "192.168.160.1:36630",
      "backend_roles" : [
        "bar",
        "foo"
      ],
      "custom_attribute_names" : [ ],
      "roles" : [
        "own_index",
        "alerting_ack_alerts"
      ],
      "tenants" : {
        "impersonator" : true
      },
      "principal" : null,
      "peer_certificates" : "0",
      "sso_logout_url" : null
    }

    curl -XGET -u impersonator:impersonator -k -H "opendistro_security_impersonate_as: user1" "https://127.0.0.1:9200/_plugins/_security/authinfo?pretty"
    {
      "user" : "User [name=user1, backend_roles=[foo, baz], requestedTenant=null]",
      "user_name" : "user1",
      "user_requested_tenant" : null,
      "remote_address" : "192.168.160.1:36634",
      "backend_roles" : [
        "foo",
        "baz"
      ],
      "custom_attribute_names" : [ ],
      "roles" : [
        "own_index",
        "alerting_read_access"
      ],
      "tenants" : {
        "user1" : true
      },
      "principal" : null,
      "peer_certificates" : "0",
      "sso_logout_url" : null
    }

