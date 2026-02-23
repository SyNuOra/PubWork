alter table syapex.ggops_paths
    add constraint ggops_paths_source_fk
        foreign key ( source )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"29443a3ef917676455cd39119f4510c235500bb9","type":"REF_CONSTRAINT","name":"GGOPS_PATHS_SOURCE_FK","schemaName":"SYAPEX","sxml":""}