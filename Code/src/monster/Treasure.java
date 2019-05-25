package monster;

import misc.DamageCalc;
import misc.DiceDamage;
import misc.DiceTreasure;

import static java.lang.Integer.parseInt;

/**
 * Creator: Patrick
 * Created: 11.05.2019
 * Purpose:
 */
public class Treasure {

    public static String scale(double scalar, String treasureStr) {
        if (treasureStr.equals("0")) return treasureStr;

        String[] parts = treasureStr.split("%");
        String diceTreasureStr;
        String item = null;
        Integer percent;
        if (parts.length == 2) {
            percent = parseInt(parts[0]);
            diceTreasureStr = parts[1];

            parts = diceTreasureStr.split("[+]");
            if (parts.length == 2){
                diceTreasureStr = parts[0];
                item = parts[1];
            } else if (parts.length == 1) {
                item = parts[0];
                diceTreasureStr = null;
            } else throw new IllegalStateException();

        } else if (parts.length == 1) {
            percent = null;

            String temp = parts[0];
            parts = temp.split("[+]");

            diceTreasureStr = parts[0];
            if (parts.length == 2) {
                item = parts[0];
            }
            // parts array of length 1 is valid.
            else if (parts.length > 2) throw new IllegalStateException();
        }
        else throw new IllegalStateException();

        if (diceTreasureStr != null) {
            DiceTreasure newTreasure = DamageCalc.scaleToClosestRange(scalar, DiceTreasure.parse(diceTreasureStr));
            diceTreasureStr = newTreasure.toString();
        } else {
            diceTreasureStr = "";
        }
        if (percent != null) {
            percent = ((int) (percent * 1.2)) + 5;
            diceTreasureStr = percent + "%" + diceTreasureStr;
        }
        if (item != null) {
            if (!diceTreasureStr.endsWith("%")) {
                diceTreasureStr += "+";
            }
            diceTreasureStr += item;
        }

        return diceTreasureStr;
    }

}
