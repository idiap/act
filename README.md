ACT for Accuracy of Connective Translation is a reference-based metric to measure the accuracy of discourse connective translation, mainly for statistical machine translation systems. The metric relies on automatic word-level alignment (using GIZA++, not included in ACT) between a source sentence and respectively the reference and candidate translations, along with other heuristics for comparing translations of discourse connectives.  Using a dictionary of equivalents, the translations are scored automatically, or, for more accuracy, semi-automatically.  The accuracy of the ACT metric was assessed by human judges on sample data for English/French, English/Arabic, English/Italian and English/German translations; the ACT scores are within 2-4% of human scores. 
The current version of ACT focuses on a small number of English connectives (although, though, even though, while, meanwhile, since, yet, however), and evaluates their translation into French, Italian, German and Arabic.
It is possible to port the ACT metric to other language pairs and to other linguistic phenomena (verbs and pronouns) that still pose problems for current SMT systems.

For more details, see ACT-V1.7-Manual-V3.pdf
