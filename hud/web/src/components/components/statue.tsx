import React, { useState, useEffect } from "react";
import { ReactSVG } from 'react-svg';
import { loaderCdn } from "../../utils/cdn";

interface StatueProps {
  statues: {
    type: string;
    color: string;
    icon: string;
    state: number;
  }[];
}

const Statue: React.FC<StatueProps> = ({ statues }) => {
  return (
    <div className="statue-wrapper">
        {statues.map((s, i) => (
            <div className="statue" data-type={s.type} data-low={s.state < 15} style={{
                ['--color' as any]: s.color,
                ['--state' as any]: `${s.state}%`,
            }} >

                <div className="progress"></div>
                <ReactSVG src={loaderCdn(s.icon)} className="icon"/>
            </div>
        ))}
    </div>
  );
};

export default Statue;
