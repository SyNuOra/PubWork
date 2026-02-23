alter table syapex.ggops_processes
    add constraint ggops_process_encryption_pr_fk
        foreign key ( encryption_profile )
            references syapex.ggops_encryption_profiles ( profile_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"c0f938105341b33e3c5cf9001a9ddd6f3b1b0d58","type":"REF_CONSTRAINT","name":"GGOPS_PROCESS_ENCRYPTION_PR_FK","schemaName":"SYAPEX","sxml":""}