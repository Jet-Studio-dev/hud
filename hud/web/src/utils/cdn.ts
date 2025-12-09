let CDN_BASE = "nui://hud/assets"
const CACHE_BUSTER = `v=${Date.now()}` 

export const loaderCdn = (path: string): string => {
  const basePath = path.startsWith('http') ? path : `${CDN_BASE}/${path}`
  return `${basePath}?${CACHE_BUSTER}`
}

export const setCdnBase = (url: string) => {
  CDN_BASE = url;
  console.log(`[CDN] Base changée → ${CDN_BASE}`);
};