create index syapex.ggops_credentials_i1 on
    syapex.ggops_credentials (
        credential_domain_id
    );


-- sqlcl_snapshot {"hash":"ee56d7b17567807ee8e6d27c3eb71f40d4cb8f4c","type":"INDEX","name":"GGOPS_CREDENTIALS_I1","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_CREDENTIALS_I1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_CREDENTIALS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CREDENTIAL_DOMAIN_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}