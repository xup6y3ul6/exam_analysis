# exam_analysis

The model names for exam study
- 3l: three-level
- lmm: linear mixed-effect model
- Z: additional random effect
- ARd: autoregressive process for days
- Hd: heterogeneity of variances/standard deviations between days
- ADm: autoregressive process for moments
- Hm: heterogeneity of variances/standard deviations between moments

1. [3l-lmm_ZHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZHm_Seed20250616_result.html)
2. [3l-lmm_ZARm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZARm_Seed20250616_result.html)
3. [3l-lmm_ZARmHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZARmHm_Seed20250616_result.html)

With Hd

4. [3l-lmm_ZHdHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZHdHm_Seed20250616_result.html)
5. [3l-lmm_ZHdARmHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZHdARmHm_Seed20250616_result.html)

With ARd
| Original | State-space model representation |
|----------|----------------------------------|
| 6. [3l-lmm_ZARdARm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZARdARm_Seed20250616_result.html) | 6'. [3l-ssm_ZARdARm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-ssm_ZARdARm_Seed20250616_result.html) |
| 7. [3l-lmm_ZARdARmHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZARdARmHm_Seed20250616_result.html) | 7'. [3l-ssm_ZARdARmHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-ssm_ZARdARmHm_Seed20250616_result.html) |

With ARd+Hd

| Original | State-space model representation |
|----------|----------------------------------|
| 8. [3l-lmm_ZARdHdARmHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-lmm_ZARdHdARmHm_Seed20250616_result.html) | 8'. [3l-ssm_ZARdHdARmHm](https://xup6y3ul6.github.io/exam_analysis/results/exam_3l-ssm_ZARdHdARmHm_Seed20250616_result.html)  |
