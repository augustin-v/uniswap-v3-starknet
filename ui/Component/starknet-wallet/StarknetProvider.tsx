// components/StarknetProvider.tsx
"use client";

import React, { ReactNode } from "react";
import {
  StarknetConfig,
  publicProvider,
  voyager,
  Connector,
} from "@starknet-react/core";
import { InjectedConnector } from "starknetkit/injected";
import { WebWalletConnector } from "starknetkit/webwallet";
import { mainnet, sepolia } from "@starknet-react/chains";

export default function StarknetProvider({ children }: { children: ReactNode }) {
  const connectors: Connector[] = [
    new InjectedConnector({ options: { id: "argentX", name: "Argent X" } }),
    new InjectedConnector({ options: { id: "braavos", name: "Braavos" } }),
    new WebWalletConnector({ url: "https://web.argent.xyz" }),
  ];

  return (
    <StarknetConfig
      connectors={connectors as Connector[]}
      provider={publicProvider()}
      chains={[mainnet, sepolia]}
      explorer={voyager}
    >
      {children}
    </StarknetConfig>
  );
}
