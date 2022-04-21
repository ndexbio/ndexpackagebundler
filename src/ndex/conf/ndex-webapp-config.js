var ndexSettings =
{
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
    refreshIntervalInSeconds: 10,
    ndexServerUri: "https://myndex.mycompany.com/v2",
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
    featuredContentScrollIntervalInMs: 3100,
    iQuery:
    {
        // not sure why serviceServerUri is subset of baseUri, but leaving it for now
        baseUri: "https://myndex.mycompany.com/integratedsearch/v1/",
        deployEnvironment: "",
        myGeneUri: "https://mygene.info/v3/query",
        geneCardsUri: "https://www.genecards.org/cgi-bin/carddisp.pl?gene=",
        helpUri: "https://github.com/cytoscape/search-portal/blob/master/README.md",
        feedBackUri: "https://home.ndexbio.org/contact-us/",
        cytoscapeUri: "https://cytoscape.org",
        ucsdUri: "https://medschool.ucsd.edu/som/medicine/research/labs/ideker/Pages/default.aspx",
        copyRight: "2021 UC San Diego Ideker Lab",
        maxNetworkSize: 5000,
        geneSetExamples: [
                     {
                      "name": "Death Receptors",
                      "genes": "APAF1 BCL2 BID BIRC2 BIRC3 CASP10 CASP3 CASP6 CASP7 CFLAR CHUK DFFA DFFB FADD GAS2 LMNA MAP3K14 NFKB1 RELA RIPK1 SPTAN1 TNFRSF25 TNFSF10 TRADD TRAF2 XIAP",
                      "description": "25 genes involved in the induction of apoptosis through DR3 and DR4/5 Death Receptors"
                     },
                     {
                      "name": "Reactive Oxygen Species",
                      "genes": "ABCC1 ATOX1 CAT CDKN2D EGLN2 ERCC2 FES FTL G6PD GCLC GCLM GLRX GLRX2 GPX3 GPX4 GSR HHEX HMOX2 IPCEF1 JUNB LAMTOR5 LSP1 MBP MGST1 MPO MSRA NDUFA6 NDUFB4 NDUFS2 NQO1 OXSR1 PDLIM1 PFKP PRDX1 PRDX2 PRDX4 PRDX6 PRNP PTPA SBNO2 SCAF4 SELENOS SOD1 SOD2 SRXN1 STK25 TXN TXNRD1 TXNRD2",
                      "description": "The 49 genes comprising the MSigDB Hallmark Gene Set for Reactive Oxygen Species Processes"
                     },
                     {
                      "name": "Coxsackie Virus-Human",
                      "genes": "YTHD3 XRN2 TM225 SETD3 RTRAF RING1 REL RAVR1 RAE1L PURB PTBP1 PRC2B PAN2 NUP98 NCBP3 MYCB2 LAR4B IMA5 IF4G1 FBSP1 FA98A F120A EIF3M EIF3L EIF3K EIF3I EIF3H EIF3G EIF3F EIF3E EIF3D EIF3C EIF3B EIF3A DPYL2 DDX1 CSK21 CPSF6 CISY CBX1 CARF C2AIL",
                      "description": "42 human host proteins that were shown to interact with the 2A protein of the Coxsackie virus in Diep et al. Nature Microbiology (2019). The larger network from the paper is, not surprisingly, the top enrichment result, but interestingly, one of the top results is a network of HIV-Human interactors that shares a set of proteins related to translation initiation."
                     }
                    ]
    }

};
