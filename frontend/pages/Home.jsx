import React from "react";
import Faq from "@/core/blocks/faq/Faq";
import Hero from "@/core/blocks/hero/Hero";
import { getTranslations } from "@/core/lib/i18n";
import Feature3 from '@/core/blocks/feature/Feature3';
import { FeatureLayout } from '@/core/blocks/feature/FeatureLayout';

export function Home() {
	const faqs = getTranslations("home.faq", {})
	const hero = getTranslations("home.hero", {})
	const features = getTranslations("home.features", [])

	return (
		<div className="flex-1 flex-col">
			<Hero hero={hero}>
			</Hero>

			<FeatureLayout>
				{features.map((feature, index) => (
					<Feature3
						key={index}
						title={feature.title}
						description={feature.description}
						features={feature.features || []}
					/>
				))}
			</FeatureLayout>
			<Faq faqs={faqs} />
		</div>
	);
}
