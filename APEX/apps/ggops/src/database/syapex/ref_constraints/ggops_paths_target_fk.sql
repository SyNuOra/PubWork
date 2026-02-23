alter table syapex.ggops_paths
    add constraint ggops_paths_target_fk
        foreign key ( target )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"19031ce468f271dba618cfb58d64d508d3c2f1d3","type":"REF_CONSTRAINT","name":"GGOPS_PATHS_TARGET_FK","schemaName":"SYAPEX","sxml":""}