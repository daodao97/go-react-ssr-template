import React from "react";
import { Flex } from "@radix-ui/themes";
import { getTranslations } from "@/core/lib/i18n";

interface Content {
    title: string
    contents: Item[]
}

interface Item {
    title: string
    description: string
}

export function Privacy({ name = "privacy" }: { name: string }) {

    const content = getTranslations(name, {}) as Content

    return (
        <Flex direction="column" gap="4" className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 pt-24">
            <h1 className="text-4xl font-bold text-white mb-8 pb-4">{content.title}</h1>
            {(content.contents || []).map((item, index) => (
                <Flex key={index} direction="column" gap="2" className="mb-8 rounded-lg p-4 transition-shadow duration-300">
                    <h3 className="text-xl font-semibold text-gray-100 dark:text-gray-50">{item.title}</h3>
                    <p className="text-gray-300 dark:text-gray-200 leading-relaxed">{item.description}</p>
                </Flex>
            ))}
        </Flex>
    );
}
