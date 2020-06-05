using UnityEngine;
using System.Collections;
using UnityEngine.Assertions;

public class CollectibleSpawner : MonoBehaviour {

	public GameObject[] prefabs;

	// Use this for initialization
	void Start () {
        Assert.IsTrue(prefabs.Length == 2); // needed for random range check

		// infinite collectible spawning function, asynchronous
		StartCoroutine(SpawnCollectibles());
	}

	// Update is called once per frame
	void Update () {

	}

	IEnumerator SpawnCollectibles() {
		while (true) {

			// number of collectibles we could spawn vertically
			int collectiblesThisRow = Random.Range(1, 4);

			// instantiate all coins in this row separated by some random amount of space
			for (int i = 0; i < collectiblesThisRow; i++) {
                int num = Random.Range(0, 5) == 4 ? 1 : 0; //20% chance
				Instantiate(prefabs[num], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
			}

            // pause 1-5 seconds until the next collectibles spawns
            yield return new WaitForSeconds(Random.Range(1, 5));
		}
	}
}
