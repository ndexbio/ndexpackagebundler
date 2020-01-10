var ndexSettings =
{
    welcome: {
        header: '<strong>Welcome to the NDEx TEST Server</strong>',
        linkToReleaseDocs: 'http://www.home.ndexbio.org/release-notes/',

        message: ''
            // 'NDEx 2.0 TEST server. This server is to be used for testing purposes by collaborators and developers. \
            //  All networks and accounts on this server can be lost at any time. \
            //  Please don&#39;t use this server to store important network content.'

            // 'NDEx 2.0 provides a major improvement in performance, scalability and reliability. \
            // This NDEx 2.0 Preview Server mimics the official NDEx Public Server and will be available for a \
            // limited time for community testing. We encourage you to try it out and provide feedback. \
            // <strong>Please keep in mind that this is just a STAGING SERVER and all of its content will be lost \
            // once it is shut down. </strong> For your important work, please keep using our official Public Server.'

            //'NDEx 2.0 provides a major improvement in performance, scalability and reliability: please review the \
            //<a href="http://www.home.ndexbio.org/release-notes" target="_blank">NDEx 2.0 Release Notes</a> \
            //for important information. With NDEx 2.0 you will experience better speed, \
            //full Cytoscape support and a streamlined REST API. We also introduced \
            //<strong>"Featured Collections"</strong> to help you get \
            //started immediately... Whether you decide to begin exploring the updated NCI/Nature-curated \
            //<a href="http://www.ndexbio.org/#/user/301a91c6-a37b-11e4-bda0-000c29202374" target="_blank"> \
            //Pathway Interaction Database</a> or browse the latest networks generated by the \
            //<a href="http://www.ndexbio.org/#/user/b47268a6-8112-11e6-b0a6-06603eb7f303" target="_blank"> \
            //Cancer Cell Maps Initiative</a>,  NDEx gives you an edge in network biology!'
    },
    logoLink:
    {
        // logoLink doesn't have label property, since we use NDEX logo image instead of text label
        href:        "http://www.ndexbio.org",
        warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
        showWarning: true
    },
    newsLink:
    {
        label:       "News",
        href:        "http://www.home.ndexbio.org/index",
        warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
        showWarning: false
    },
    aboutLink:
    {
        label:       "About",
        href:        "http://www.ndexbio.org/about-ndex",
        warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
        showWarning:  true 
    },
    documentationLink:
    {
        label:       "Docs",
        href:        "http://www.ndexbio.org/quick-start",
        warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
        showWarning: true 
    },
    apiLink:
    {
        label:       "API",
        //href:        "http://public.ndexbio.org/#/api",
        href:        "#/api",
        warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
        showWarning: true 
    },
    reportBugLink:
    {
        label:       "Report Bug",
        href:        "http://www.ndexbio.org/report-a-bug",
        warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
        showWarning: true
    },
    contactUsLink:
    {
        label:       "Contact Us",
        href:        "https://www.ndexbio.org/contact-us",
        warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
        showWarning: true 
    },

    messages:
    {
	serverDown: "<img src='https://home.ndexbio.org/img/maintenance2.png'>"
    },
    requireAuthentication: false,
    signIn:
    {
        header: "Sign in to your NDEx account",
        footer: "Need an account?",
        showForgotPassword: true,
        showSignup: true
    },
    searchDocLink:
    {
    	label:       "Documentation on Searching in NDEx",
    	href:        "https://home.ndexbio.org/finding-and-querying-networks/#searchexamples",
    	warning:     "Warning! Dragons ahead... Click OK to proceed at your own risk or click CANCEL to go back to safety.",
    	showWarning: false
    },
    featuredCollections: [
        {
            name: 'Pathway Interaction Database (NCI-PID)',
            UUID: '301a91c6-a37b-11e4-bda0-000c29202374',
            account: 'user'
        },
        {
            name: 'Cancer Cell Maps Initiative (CCMI)',
            UUID: 'b47268a6-8112-11e6-b0a6-06603eb7f303',
            account: 'user'
        },
        {
            name: 'The NDEx Butler',
            UUID: '08cd9aae-08af-11e6-b550-06603eb7f303',
            account: 'user'
        },
        {
            name: 'NetPath',
            UUID: 'ab10afd9-e488-11e4-951c-000c29cb28fb',
            account: 'user'
        },
        {
            name: 'Ideker Lab',
            UUID: 'a75465c5-72a3-11e5-b435-06603eb7f303',
            account: 'group'
        }
    ],
    refreshIntervalInSeconds: 15,
    ndexServerUri: "https://test.ndexbio.org/v2",
    googleClientId: '802839698598-shh458t46bo9v2v5iolcvk1h443hid6n.apps.googleusercontent.com',
    networkQueryLimit: 50000,
    networkDisplayLimit: 500,
    networkTableLimit: 500,
    idleTime: 3600,
    uploadSizeLimit: "none",
    googleAnalyticsTrackingCode: 'UA-62588031-5',
    // specifies network with that many edges that open in Cytoscape without warning
    openInCytoscapeEdgeThresholdWarning: 300000,
    linkToReleaseDocs: 'https://home.ndexbio.org/release-notes/',
    landingPageConfigServer: 'https://staging.ndexbio.org/landing_page_content/v2_4_2',
    featuredContentScrollIntervalInMs: 3100


};
