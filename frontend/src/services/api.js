import axios from 'axios';

const getBaseURL = () => {
    if (import.meta.env.VITE_API_URL) return import.meta.env.VITE_API_URL;
    // Fallback for local development: use current hostname if accessing via localhost or IP
    const host = window.location.hostname;
    if (host === 'localhost' || /^(\d{1,3}\.){3}\d{1,3}$/.test(host)) {
        return `http://${host}:8000`;
    }
    return ''; // Relative path if on the same host (e.g. production)
};

const api = axios.create({
    baseURL: getBaseURL(),
});

// Add a request interceptor
api.interceptors.request.use(
    (config) => {
        try {
            const token = typeof window !== 'undefined' && window.localStorage ? localStorage.getItem('token') : null;
            if (token) {
                config.headers.Authorization = `Bearer ${token}`;
            }
        } catch (e) {
            console.warn('LocalStorage access blocked in api request:', e);
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Add a response interceptor
api.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response && error.response.status === 401) {
            try {
                if (typeof window !== 'undefined' && window.localStorage) {
                    localStorage.removeItem('token');
                }
            } catch (e) {
                console.warn('LocalStorage remove blocked in api response:', e);
            }
            // Preserve current query parameters during redirect
            const params = window.location.search;
            window.location.href = `/login${params}`;
        }
        return Promise.reject(error);
    }
);

export default api;
