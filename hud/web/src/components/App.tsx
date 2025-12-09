import React, { useState, useEffect } from "react";
import { ReactSVG } from 'react-svg';
import "./App.scss";

import { isEnvBrowser } from '../utils/misc';
import { loaderCdn, setCdnBase } from "../utils/cdn";
import { translate, setLocaleData }from "../utils/locale";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";

import Statue from "./components/statue";

interface StatueItem {
  type: string;
  color: string;
  icon: string;
  state: number;
}

debugData([
  { 
    action: 'setVisible', 
    data: true 
  },
]);

debugData([
  { 
    action: "hud:setStatues",
    data: [
      { type: "health", color: "#2EC25A", icon: "icon/hud/health.svg", state: 70 },
      { type: "hunger", color: "#C26B2E", icon: "icon/hud/hunger.svg", state: 30 },
      { type: "thirst", color: "#2EA7C2", icon: "icon/hud/thirst.svg", state: 70 },
    ]
  },
]);

const App: React.FC = () => {
  const [statues, setStatues] = useState<StatueItem[]>([]);

  useNuiEvent("hud:setStatues", (data: any) => setStatues(data));

  useNuiEvent("hud:setRatio", (data: any) => {
    if (!data) return;
    if (data.vwc) document.documentElement.style.setProperty("--vw-c", data.vwc.toString());
    if (data.vhc) document.documentElement.style.setProperty("--vh-c", data.vhc.toString());
  });
  
  return (
    <div className={`hud-wrapper ${isEnvBrowser() ? "env-browser" : ""}`}>
      <Statue statues={statues} />
    </div>
  );
};

export default App;

