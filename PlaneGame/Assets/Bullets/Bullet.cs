using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public AudioSource audioSource;

    [SerializeField] private GameObject m_MiniExplosionVFX;

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Enemy") || other.gameObject.CompareTag("Player"))
        {
            audioSource.Play();
            var HM = other.gameObject.GetComponent<HealthManager>();
            if (HM.HP > 0)
            {
                HM.TakeHP(1);
                //ADD FIRE EFFECT

                var explosion = Instantiate(m_MiniExplosionVFX, transform.position, transform.rotation);

                Destroy(explosion, 1.5f);

            }
        }

        Destroy(gameObject, 1);
    }
}
