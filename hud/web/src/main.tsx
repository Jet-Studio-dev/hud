import React, { useEffect } from 'react';
import ReactDOM from 'react-dom/client';
import { VisibilityProvider } from './providers/VisibilityProvider';
import { fetchNui } from './utils/fetchNui';
import App from './components/App';
import './index.css';

const Root = () => {
  useEffect(() => {
    fetchNui('nui:ready');
  }, []);

  return (
    <React.StrictMode>
      <VisibilityProvider>
        <App />
      </VisibilityProvider>
    </React.StrictMode>
  );
};

ReactDOM.createRoot(document.getElementById('root')!).render(<Root />);