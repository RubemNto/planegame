using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public Vector2 minMaxHorizontal;
    public Vector2 minMaxVertical;
    public int spawnsCount;
    public float timeBetweenSpawns;
    private float _time;

    public GameObject enemyPrefab;

    private void Start()
    {
        _time = timeBetweenSpawns;
    }

    private void Update()
    {
        if (_time <= 0)
        {
            for (int spawn = 0; spawn < spawnsCount; spawn++)
            {
                Vector3 pos = new Vector3(
                    transform.position.x,
                    transform.position.y, transform.position.z) + transform.right * Random.Range(minMaxHorizontal.x, minMaxHorizontal.y);
                pos += transform.forward * Random.Range(-5, 5);
                var enemyInstance = Instantiate(enemyPrefab, pos, transform.rotation);
                enemyInstance.GetComponent<Gun>().canShoot = Random.Range(1.0f, 100.0f) > 90.0f ? true : false;
            }
            _time = timeBetweenSpawns;
        }
        else
        {
            _time -= Time.deltaTime;
        }
    }
}
