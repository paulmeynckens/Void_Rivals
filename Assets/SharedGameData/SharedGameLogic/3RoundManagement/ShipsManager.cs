using UnityEngine;
using System.Collections;

namespace RoundManagement
{
    public class ShipsManager : MonoBehaviour
    {
        public static ShipsManager instance;

        
        private void Awake()
        {
            instance = this;

            
        }





        public ShipsSpawnerDictionnary shipSpawners = null;

        
    }
}