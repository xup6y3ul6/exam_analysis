# exam_analysis

The model names for exam study
- 3l: three-level
- lmm: linear mixed-effect model
- Z: additional random effect
- ARd: autoregressive process for days
- Hd: heterogeneity of variances/standard deviations between days
- ADm: autoregressive process for moments
- Hm: heterogeneity of variances/standard deviations between moments


## Stan 

1. [3l-lmm_ZHm](results/exam_3l-lmm_ZHm_Seed20250616_result.html)
2. [3l-lmm_ZARm](results/exam_3l-lmm_ZARm_Seed20250616_result.html)
3. [3l-lmm_ZARmHm](results/exam_3l-lmm_ZARmHm_Seed20250616_result.html)

With Hd

4. [3l-lmm_ZHdHm](results/exam_3l-lmm_ZHdHm_Seed20250616_result.html)
5. [3l-lmm_ZHdARmHm](results/exam_3l-lmm_ZHdARmHm_Seed20250616_result.html)

With ARd
| Original | State-space model representation |
|----------|----------------------------------|
| 6. [3l-lmm_ZARdARm](results/exam_3l-lmm_ZARdARm_Seed20250616_result.html) | 6'. [3l-ssm_ZARdARm](results/exam_3l-ssm_ZARdARm_Seed20250616_result.html) |
| 7. [3l-lmm_ZARdARmHm](results/exam_3l-lmm_ZARdARmHm_Seed20250616_result.html) | 7'. [3l-ssm_ZARdARmHm](results/exam_3l-ssm_ZARdARmHm_Seed20250616_result.html) |

With ARd+Hd+RId

| Original | State-space model representation |
|----------|----------------------------------|
| 8. [3l-lmm_ZARdHdARmHm](results/exam_3l-lmm_ZARdHdARmHm_Seed20250616_result.html) | 8'. [3l-ssm_ZARdHdARmHm](results/exam_3l-ssm_ZARdHdARmHm_Seed20250616_result.html)  |


With ARd+Hd (without RId)
| Original | State-space model representation |
|----------|----------------------------------|
| 9. [3l-lmm_ZARdHdARmHm_woRId](results/exam_3l-lmm_ZARdHdARmHm_woRId_Seed20250708_result.html) | 9'. [3l-ssm_ZARdHdARmHm_woRId](results/exam_3l-ssm_ZARdHdARmHm_woRId_Seed20250708_result.html)  |


## Jags

[multiple models](results/exam_study_by_jags.html)

1. 3l-lmm_ZRIdHdARmHm
2. 3l-lmm_RIdHdARmHm
3. 3l-lmm_ZARdHdARmHm_woRId
4. 3l-lmm_RIdARmHm
5. 3l-lmm_RIdARm