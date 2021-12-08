#!/bin/bash
"/usr/share/opensearch/plugins/opensearch-security/tools/securityadmin.sh" -h localhost -cd "/usr/share/opensearch/plugins/opensearch-security/securityconfig" -icl -key "/usr/share/opensearch/config/kirk-key.pem" -cert "/usr/share/opensearch/config/kirk.pem" -cacert "/usr/share/opensearch/config/root-ca.pem" -nhnv
