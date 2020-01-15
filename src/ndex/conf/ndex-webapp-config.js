var ndexSettings =
{
    messages:
    {
	serverDown: "<img src='http://home.ndexbio.org/img/maintenance2.png'>"
    },
    requireAuthentication: false,
    signIn:
    {
        header: "Sign in to your NDEx account",
        footer: "Need an account?",
        showForgotPassword: true,
        showSignup: true
    },
    refreshIntervalInSeconds: 10,
    ndexServerUri: "http://myndex.mycompany.com/v2",
    googleClientId: '802839698598-shh458t46bo9v2v5iolcvk1h443hid6n.apps.googleusercontent.com',
    networkQueryLimit: 50000,
    networkDisplayLimit: 500,
    networkTableLimit: 500,
    idleTime: 3600,
    uploadSizeLimit: "none",

    // googleAnalyticsTrackingCode: 'XXXXXXX',
    // specifies network with that many edges that open in Cytoscape without warning
    openInCytoscapeEdgeThresholdWarning: 300000,
    linkToReleaseDocs: 'https://home.ndexbio.org/release-notes/',
    landingPageConfigServer: 'https://staging.ndexbio.org/landing_page_content/v2_4_2',
    featuredContentScrollIntervalInMs: 3100
};
