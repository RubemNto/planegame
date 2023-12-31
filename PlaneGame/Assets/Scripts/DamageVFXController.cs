using UnityEngine;

public class DamageVFXController : MonoBehaviour
{
    private readonly int m_FlameHeightPropId = Shader.PropertyToID("_FlameHeight");

    [SerializeField] private ParticleSystem[] m_SmokeVFXs;
    [SerializeField] private MeshRenderer[] m_FireVFXs;

    private Material[] m_FireMaterials;

    private void Start()
    {
        m_FireMaterials = new Material[m_FireVFXs.Length];

        for (int i = 0; i < m_FireVFXs.Length; i++)
        {
            m_FireMaterials[i] = m_FireVFXs[i].material;

            m_FireVFXs[i].gameObject.SetActive(false);
        }

        foreach (var smoke in m_SmokeVFXs)
        {
            var emissionModule = smoke.emission;
            emissionModule.rateOverTime = 0;
        }
    }

    public void UpdateDamageAmount(float amount)
    {
        foreach (var smoke in m_SmokeVFXs)
        {
            var emissionModule = smoke.emission;
            emissionModule.rateOverTime = amount * 100.0f;
            emissionModule.rateOverDistance = amount * 20.0f;
        }

        int i = 0;
        foreach (var fire in m_FireMaterials)
        {
            float flameSize = (1.0f - amount) * 2.0f;
            if (flameSize < 1.5f)
            {
                fire.SetFloat(m_FlameHeightPropId, flameSize < 0.5f ? 0.5f : flameSize);

                if (!m_FireVFXs[i].gameObject.activeInHierarchy)
                {
                    m_FireVFXs[i].gameObject.SetActive(true);
                }
            }
            else
            {
                m_FireVFXs[i].gameObject.SetActive(false);
            }

            i++;
        }
    }
}
