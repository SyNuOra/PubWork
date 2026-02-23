create index syapex.ggops_encryption_p_i1 on
    syapex.ggops_encryption_profiles (
        deployment_id
    );


-- sqlcl_snapshot {"hash":"6175ac5151c119b01a896250fbf68388a86d979d","type":"INDEX","name":"GGOPS_ENCRYPTION_P_I1","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_ENCRYPTION_P_I1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_ENCRYPTION_PROFILES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DEPLOYMENT_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}