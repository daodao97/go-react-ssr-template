import React from 'react';
import { t } from '@/core/lib/i18n';

export function NotFound() {
    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-100 dark:bg-gray-900">
            <div className="text-center">
                <h1 className="text-6xl font-bold text-gray-900 dark:text-white mb-4">404</h1>
                <p className="text-xl text-gray-600 dark:text-gray-300 mb-8">{t('pageNotFound', 'Page not found')}</p>
                <a
                    href="/"
                    className="inline-block bg-blue-500 hover:bg-blue-600 dark:bg-blue-600 dark:hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition-colors"
                >
                    {t('backToHome', 'Back to home')}
                </a>
            </div>
        </div>
    );
}
