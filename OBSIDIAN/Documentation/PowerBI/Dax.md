#powerbi

Dax 建表语句
``` sql
Segment = 
DATATABLE (
    "GTM Segment", STRING,
    "GTM SubSegment", STRING,
    {
        {"Consumer", "Global"},
        {"Consumer", "Large Enterprise"},
        {"Consumer", "Public"},
        {"Consumer", "Education"},
        {"SMB", "Global"},
        {"SMB", "Mid Market"},
        {"SMB", "Small Market"},
        {"Commercial", "Global"},
        {"Commercial", "Large Enterprise"},
        {"Commercial", "Public"},
        {"Commercial", "Education"},
        {"Commercial", "Mid Market"},
        {"Commercial", "Web"},
        {"Commercial", "Retail"}
    }
)
```

