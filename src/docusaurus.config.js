module.exports = {
  title: '101',
  tagline: 'The tagline of my site',
  url: 'https://your-docusaurus-test-site.com',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  favicon: 'img/favicon.ico',
  organizationName: 'felipepiovezan', // Usually your GitHub org/user name.
  projectName: 'blog', // Usually your repo name.
  themeConfig: {
    sidebarCollapsible: false, // make sidebar expanded by default.
    navbar: {
      title: 'Blog',
      logo: {
        alt: 'My Site Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          href: 'https://github.com/felipepiovezan',
          label: 'GitHub',
          position: 'left',
        },
        {
          href: 'https://twitter.com/fpiovezan',
          label: 'Twitter',
          position: 'left',
        },
        {
          href: 'https://linkedin.com/in/felipepiovezan',
          label: 'LinkedIn',
          position: 'left',
        },
      ],
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          routeBasePath: '/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
