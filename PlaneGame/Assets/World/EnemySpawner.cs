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
                Instantiate(enemyPrefab, pos, transform.rotation);
            }
            _time = timeBetweenSpawns;
        }
        else
        {
            _time -= Time.deltaTime;
        }
    }
}
