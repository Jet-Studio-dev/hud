let LOCALE_DATA: Record<string, string> = {};

export const setLocaleData = (data: Record<string, string>) => {
  LOCALE_DATA = data;
  console.log(`[Locale] Données de locale chargées (${Object.keys(data).length} clés)`);
};

export const translate = (key: string,) => {
  let text = LOCALE_DATA[key] || key;

  return text;
};
