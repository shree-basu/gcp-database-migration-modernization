Architecture

  SOURCE DB  --assess-->  Assessment tooling (profiler + compat + typemap)
  (PG/Oracle)
      |
      | full load + CDC (WAL / LogMiner)
      v
  Database Migration Service  --promote-->  TARGET DB (Cloud SQL / AlloyDB)
  (connection profiles, continuous job)          |
                                                  v
                        reconcile (schema/rows/checksum/sample)
                                                  |
                                                  v
                               reconciliation.html  (PASS gate before cutover)